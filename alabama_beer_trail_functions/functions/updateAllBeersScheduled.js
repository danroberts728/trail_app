const firebase = require('firebase-admin');
const rp = require('request-promise');

// Configuration
const clientId = "F8C03C8BD8F246A332CACD824B56A99F8ED5B6A7";
const clientSecret = "994F45EC5D80CD2E94D2D508954958A2362D75B3";
var methodUrl = "https://api.untappd.com/v4/brewery/info/";
const placesFirestoreCollection = 'places';
const allBeersCollection = 'all_beers';
const last_update_field = 'last_all_beers_update';
const update_limit = 25;

// Get Untappd Beer List
const functions = require('firebase-functions');
exports.updateAllBeersScheduled = functions.pubsub
    .schedule('every 24 hours')
    .onRun((context) => {
        return firebase.firestore().collection(placesFirestoreCollection)
            .orderBy(last_update_field)
            .limit(update_limit)
            .get()
            .then(querySnapshot => {
                // Get places to update (everything)
                let placesToUpdate = {};
                querySnapshot.forEach(doc => {
                    var data = doc.data();
                    if (data.hasOwnProperty('connections') &&
                        data.connections.hasOwnProperty('untappd') &&
                        data.connections.untappd !== "") {
                        placesToUpdate[doc.id] = data.connections.untappd;
                    }
                });
                return placesToUpdate;
            }).then(placesToUpdate => {
                // Get the untappd information for each place to update
                console.log(`${Object.keys(placesToUpdate).length} places to update this batch`);
                var promises = [];
                Object.keys(placesToUpdate).forEach(p => {
                    var place_id = p;
                    var untappdId = placesToUpdate[p];
                    var url = `${methodUrl}/${untappdId}/?client_id=${clientId}&client_secret=${clientSecret}`;
                    promises.push(getBeerData(place_id, url));
                });
                return Promise.all(promises);
            }).then(allBeerData => {
                /// All beer data received. Parse it to standard objects
                console.log(`${Object.keys(allBeerData).length} places parsed`);
                let places_beer_data = [];
                allBeerData.forEach(d => {
                    let place_id = d.place_id;
                    let untappd_data = d.result;

                    let beer_data = [];

                    if(untappd_data.hasOwnProperty('response')
                        && untappd_data.response.hasOwnProperty('brewery')
                        && untappd_data.response.brewery.hasOwnProperty('beer_list')
                        && untappd_data.response.brewery.beer_list.hasOwnProperty('count')
                        && untappd_data.response.brewery.beer_list.hasOwnProperty('items')) {
                            for (var i = 0; i < untappd_data.response.brewery.beer_list.count; i++) {
                                try {
                                    var beerData = untappd_data.response.brewery.beer_list.items[i].beer;
                                    var untappdId = beerData.hasOwnProperty('bid') ? beerData.bid : 0;
                                    var beerName = beerData.hasOwnProperty('beer_name') ? beerData.beer_name : "";
                                    var beerLabel = beerData.hasOwnProperty('beer_label') ? beerData.beer_label : "";
                                    var beerStyle = beerData.hasOwnProperty('beer_style') ? beerData.beer_style : "";
                                    var beerAbv = beerData.hasOwnProperty('beer_abv') ? beerData.beer_abv : 0;
                                    var beerIbu = beerData.hasOwnProperty('beer_ibu') ? beerData.beer_ibu : 0;
                                    var beerSlug = beerData.hasOwnProperty('beer_slug') ? beerData.beer_slug : untappdId.toString();
                                    var beerDescription = beerData.hasOwnProperty('beer_description') ? beerData.beer_description : "";
                                    var isInProduction = beerData.hasOwnProperty('is_in_production') ? beerData.is_in_production : true;
                                    var ratingScore = beerData.hasOwnProperty('rating_score') ? beerData.rating_score : 0;
                                    var ratingCount = beerData.hasOwnProperty('rating_count') ? beerData.rating_count : 0;
    
                                    beer_data.push({
                                        'beer_abv': beerAbv,
                                        'beer_description': beerDescription,
                                        'beer_ibu': beerIbu,
                                        'beer_slug': beerSlug,
                                        'beer_label': beerLabel,
                                        'beer_name': beerName,
                                        'beer_style': beerStyle,
                                        'is_in_production': isInProduction,
                                        'untappdId': untappdId,
                                        'untappd_rating_count': ratingCount,
                                        'untappd_rating_score': ratingScore
                                    });
                                } catch (err) {
                                    console.error(err);
                                }
                            }
                        }
                    places_beer_data.push({
                        'place_id': place_id,
                        'new_beers': beer_data
                    });
                });
                return places_beer_data
            }).then(places_beer_data => {
                // Add in the existing beer data to the place objects
                let promises = [];
                places_beer_data.forEach(place => {
                    promises.push(
                        addExistingBeerData(place.place_id, place.new_beers)
                    );
                });
                return Promise.all(promises);
            }).then(places_beer_data => {
                // Finally, update the beer list for each place
                places_beer_data.forEach(place => {
                    updateFirebaseBeers(place);
                });
                return true;
            }).then(result => {
                console.log("All Beers Updated!");
                return true;
            }).catch(error => {
                // API call failed...
                console.error("Error: " + error);
            });
    });


/// Update the beer information on Firebase
/// This uses a batch process to atomically change the
/// firestore in one call
function updateFirebaseBeers(place) {
    const batch = firebase.firestore().batch();

    // Remove old_beers that aren't in new_beers
    let new_beer_ids = place.new_beers.map(n => n.untappdId);
    let remove_from_list = place.old_beers.filter(o => !new_beer_ids.includes(o.untappdId));
    remove_from_list.forEach(b => {
        console.log(`${place.place_id}: Remove ${b.beer_name} (${b.untappdId})`);
        let docRef = firebase.firestore().collection(placesFirestoreCollection).doc(place.place_id)
            .collection(allBeersCollection).doc(String(b.untappdId))
        batch.delete(docRef);
    });

    // Add new_beers that aren't in old_beers
    let old_beer_ids = place.old_beers.map(o => o.untappdId);
    let add_to_list = place.new_beers.filter(n => !old_beer_ids.includes(n.untappdId));
    add_to_list.forEach(b => {
        console.log(`${place.place_id}: Add ${b.beer_name} (${b.untappdId})`);
        let docRef = firebase.firestore().collection(placesFirestoreCollection).doc(place.place_id)
            .collection(allBeersCollection).doc(String(b.untappdId));
        batch.set(docRef, b);
    });

    // Update existing beers if they are different
    let check_for_updates_list = place.new_beers.filter(n => old_beer_ids.includes(n.untappdId));
    check_for_updates_list.forEach(new_beer => {
        let old_beer = place.old_beers.find(o => o.untappdId === new_beer.untappdId);
        if (!beersAreEqual(old_beer, new_beer)) {
            console.log(`${place.place_id}: Update ${old_beer.beer_name} (${old_beer.untappdId})`);
            let docRef = firebase.firestore().collection(placesFirestoreCollection).doc(place.place_id)
                .collection(allBeersCollection).doc(String(old_beer.untappdId));
            batch.update(docRef, new_beer);
        }
    });

    // Update last update timestamp
    let docRef = firebase.firestore().collection(placesFirestoreCollection).doc(place.place_id);
    let updatedInfo = {last_all_beers_update: firebase.firestore.Timestamp.now()}
    batch.update(docRef, updatedInfo);

    return batch.commit();
}

function beersAreEqual(a, b) {
    return a.beer_abv === b.beer_abv
        && a.beer_description === b.beer_description
        && a.beer_ibu === b.beer_ibu
        && a.beer_slug === b.beer_slug
        && a.beer_label === b.beer_label
        && a.beer_name === b.beer_name
        && a.beer_style === b.beer_style
        && a.is_in_production === b.is_in_production
        && a.untappdId === b.untappdId
        && a.untappd_rating_count === b.untappd_rating_count
        && a.untappd_rating_score === b.untappd_rating_score;
}

/// Return a promise with the beer data for [place_id].
function getBeerData(place_id, url) {
    let options = {
        uri: url,
        json: true
    };
    return rp(options).then(result => {
        return {
            'place_id': place_id,
            'result': result
        }
    });
}

/// Return an object with place_id, new_beers, and add old_beers
/// based on a firebase query
function addExistingBeerData(place_id, new_beers) {
    let beer_information = [];
    return firebase.firestore().collection(placesFirestoreCollection)
        .doc(place_id).collection(allBeersCollection).get()
        .then(querySnapshot => {
            querySnapshot.forEach(doc => {
                let data = doc.data();
                beer_information.push(
                    {
                        'beer_abv': data.beer_abv,
                        'beer_description': data.beer_description,
                        'beer_ibu': data.beer_ibu,
                        'beer_slug': data.beer_slug,
                        'beer_label': data.beer_label,
                        'beer_name': data.beer_name,
                        'beer_style': data.beer_style,
                        'is_in_production': data.is_in_production,
                        'untappdId': data.untappdId,
                        'untappd_rating_count': data.untappd_rating_count,
                        'untappd_rating_score': data.untappd_rating_score
                    }
                )
            });
            return {
                'place_id': place_id,
                'new_beers': new_beers,
                'old_beers': beer_information
            };
        })
        .catch(error => {
            console.error(`Error addExistingBeerData(): ${error}`);
        });
}