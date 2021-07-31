const firebase = require('firebase-admin');

// Configuration
const rp = require('request-promise');
const base_api_url = "https://alabama.beer/api/v1";
const placesFirestoreCollection = 'places';
const onTapCollection = 'on_tap';
const venue_names = require('./place_id_venue_matches.json');

const functions = require('firebase-functions');
const { firestore } = require('firebase-admin');
exports.updateOnTapSmartScheduled = functions.pubsub.schedule('every 12 hours').onRun((context) => {
    return firebase.firestore().collection(placesFirestoreCollection).get()
        .then(querySnapshot => {
            // Get trail_place_ids and their alabama_dot_beer_id   
            var placesToUpdate = {};
            querySnapshot.forEach(doc => {
                var data = doc.data();
                if (data.hasOwnProperty('alabama_dot_beer_id')) {
                    // Get id
                    var alabama_dot_beer_id = data.alabama_dot_beer_id;
                    placesToUpdate[doc.id] = alabama_dot_beer_id;
                }
            });
            return placesToUpdate;
        }).then(placesToUpdate => {
            // Get All tap data for each place to update
            console.log(`${Object.keys(placesToUpdate).length} places found`);
            var promises = [];
            Object.keys(placesToUpdate).forEach(p => {
                var place_id = p;
                var venue_id = placesToUpdate[p];
                var url = `${base_api_url}/venues/${venue_id}/beers/?format=json`;
                promises.push(getTapData(place_id, url, []));
            });
            return Promise.all(promises);
        }).then(allTapData => {
            /// All tap data received. Parse it to standard object
            console.log(`${Object.keys(allTapData).length} places parsed`);
            let places_tap_data = [];
            allTapData.forEach(t => {
                let place_id = t.place_id;
                let tapData = t.tapData;

                let tap_information = [];
                tapData.forEach(beer => {
                    let prices = [];
                    beer.prices.forEach(p => {
                        if (p.venue === venue_names[place_id]) {
                            prices.push({
                                'serving_size_name': p.serving_size.name,
                                'serving_size_volume_oz': p.serving_size.volume_oz,
                                'price': p.price
                            });
                        }
                    });
                    let description = "";
                    if (beer.untappd_metadata
                        && beer.untappd_metadata.json_data
                        && beer.untappd_metadata.json_data.beer_description) {
                            description = beer.untappd_metadata.json_data.beer_description;
                    }
                    let untappd_url = "";
                    if(beer.untappd_url) {
                        untappd_url = beer.untappd_url;
                    }
                    tap_information.push(
                        {
                            'beer_id': beer.id,
                            'manufacturer_name': beer.manufacturer.name,
                            'abv': beer.abv,
                            'style': beer.style === null
                                ? ""
                                : beer.style.name,
                            'name': beer.name,
                            'ibu': beer.ibu,
                            'logo_url': beer.logo_url,
                            'prices': prices,
                            'description': description,
                            'untappd_url': untappd_url
                        }
                    )
                });
                places_tap_data.push({
                    'place_id': place_id,
                    'new_taps': tap_information
                })
            });
            return places_tap_data;
        }).then(placesTapData => {
            // Add in the existing tap data to the place objects
            let promises = [];
            placesTapData.forEach(place => {
                promises.push(
                    addExistingTapData(place.place_id, place.new_taps)
                );
            });
            return Promise.all(promises);
        }).then(placesTapData => {
            // Finally, update the tap list for each place
            placesTapData.forEach(place => {
                updateFirebaseTaps(place);
            });
            return true;
        }).catch(error => {
            // Failure...
            console.error("Error: " + error);
        });
});

/// Update the tap information on Firebase
/// This uses a batch process to atomically change the
/// firestore in one call
function updateFirebaseTaps(place) {
    const batch = firebase.firestore().batch();

    // Remove old_taps that aren't in new_taps
    let new_tap_ids = place.new_taps.map(n => n.beer_id);
    let remove_from_list = place.old_taps.filter(o => !new_tap_ids.includes(o.beer_id));
    remove_from_list.forEach(t => {
        console.log(`${place.place_id}: Remove ${t.name} (${t.beer_id})`);
        let docRef = firebase.firestore().collection(placesFirestoreCollection).doc(place.place_id)
            .collection(onTapCollection).doc(String(t.beer_id))
        batch.delete(docRef);
    });

    // Add new_taps that aren't in old_taps
    let old_tap_ids = place.old_taps.map(o => o.beer_id);
    let add_to_list = place.new_taps.filter(n => !old_tap_ids.includes(n.beer_id));
    add_to_list.forEach(t => {
        console.log(`${place.place_id}: Add ${t.name} (${t.beer_id})`);
        let docRef = firebase.firestore().collection(placesFirestoreCollection).doc(place.place_id)
            .collection(onTapCollection).doc(String(t.beer_id));
        batch.set(docRef, t);
    });

    // Update existing taps if they are different
    let check_for_updates_list = place.new_taps.filter(n => old_tap_ids.includes(n.beer_id));
    check_for_updates_list.forEach(new_tap => {
        let old_tap = place.old_taps.find(o => o.beer_id === new_tap.beer_id);
        if (!tapsAreEqual(old_tap, new_tap)) {
            console.log(`${place.place_id}: Update ${old_tap.name} (${old_tap.beer_id})`);
            let docRef = firebase.firestore().collection(placesFirestoreCollection).doc(place.place_id)
                .collection(onTapCollection).doc(String(old_tap.beer_id));
            batch.update(docRef, new_tap);
        }
    });

    return batch.commit();
}

/// Test if the two taps (old and new, presumably)
/// have equal values
function tapsAreEqual(a, b) {
    return a.beer_id === b.beer_id
        && a.manufacturer_name === b.manufacturer_name
        && a.abv === b.abv
        && a.style === b.style
        && a.name === b.name
        && a.ibu === b.ibu
        && a.logo_url === b.logo_url
        && a.description === b.description
        && a.untappd_url === b.untappd_url
        && pricesAreEqual(a.prices, b.prices);
}

/// Test for equality of the pricing information
/// This assumes the indexes are equal, which isn't
/// perfect but should work based on how the information
/// is inserted.
function pricesAreEqual(a, b) {
    let isEqual = true;
    if (a.length !== b.length) {
        isEqual = false;
    } else {
        for (let i = 0; i < a.length; i++) {
            let a_tap = a[i];
            let b_tap = b[i];
            if (a_tap.price !== b_tap.price
                || a_tap.serving_size_name !== b_tap.serving_size_name
                || a_tap.serving_size_volume_oz !== b_tap.serving_size_volume_oz) {
                isEqual = false;
                break;
            }
        }
    }
    return isEqual;
}

/// Return an object with place_id, new_taps, and add old_taps
/// based on a firebase query
function addExistingTapData(place_id, new_taps) {
    let tap_information = [];
    return firebase.firestore().collection(placesFirestoreCollection)
        .doc(place_id).collection(onTapCollection).get()
        .then(querySnapshot => {
            querySnapshot.forEach(doc => {
                let data = doc.data();
                tap_information.push(
                    {
                        'beer_id': doc.id,
                        'manufacturer_name': data.manufacturer_name,
                        'abv': data.abv,
                        'style': data.style,
                        'name': data.name,
                        'ibu': data.ibu,
                        'logo_url': data.logo_url,
                        'prices': data.prices,
                        'description': data.description !== null
                            ? data.description
                            : "",
                        'untappd_url': data.untappd_url !== null
                            ? data.untappd_url
                            : ""
                    }
                )
            });
            return {
                'place_id': place_id,
                'new_taps': new_taps,
                'old_taps': tap_information
            };
        })
        .catch(error => {
            console.error(`Error addExistingTapData(): ${error}`);
        });
}

/// Return a promise with the tap data for [place_id].
/// This is recursive to get paginated data.
function getTapData(place_id, url, tapData) {
    let options = {
        uri: url,
        json: true
    };
    return rp(options)
        .then(response => {
            let retrievedTapData = tapData.concat(response.results);
            if (response.next !== null) {
                // There is more, so let's go get it.                
                return getTapData(place_id, response.next, retrievedTapData);
            } else {
                // No more, send back
                return {
                    'place_id': place_id,
                    'tapData': retrievedTapData
                };
            }
        })
        .catch(error => {
            console.error(`Error getTapData(): ${error}`);
        });
}