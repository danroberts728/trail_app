const firebase = require('firebase-admin');

// Configuration
const rp = require('request-promise');
const placesApiKey = 'AIzaSyAshVA7J5p0WO83M6H-q_-0HIF4XTQjH5Q';
const placesFirestoreCollection = 'places';
const placesJsonUrl = 'https://maps.googleapis.com/maps/api/place/details/json?';
const runTimeOptsForHoursUpdate = {
    timeoutSeconds: 540,
    memory: '512MB'
}
var placesToUpdate = {};

// Update hours
const functions = require('firebase-functions');
exports.updateHoursScheduled = functions.runWith(runTimeOptsForHoursUpdate).pubsub.schedule('every 48 hours').onRun((context) => {
    return firebase.firestore().collection(placesFirestoreCollection).get()
        .then(querySnapshot => {
            // Get trail_place_ids and their google_place_ids        
            querySnapshot.forEach(doc => {
                var data = doc.data();
                if (data.hasOwnProperty('google_place_id')) {
                    // Get place ID
                    var google_place_id = data.google_place_id;
                    placesToUpdate[doc.id] = google_place_id;
                }
            });
            return placesToUpdate;
        }).then(placesToUpdate => {
            // Get hours from the Places API for locations with a google_place_id
            var promises = [];
            for (var p in placesToUpdate) {
                google_place_id = placesToUpdate[p];
                const url = placesJsonUrl + "key=" + placesApiKey + "&place_id=" + google_place_id + "&fields=opening_hours,place_id";
                var options = {
                    uri: url,
                    json: true
                };
                promises.push(
                    rp(options)
                );
            }
            return Promise.all(promises);
        }).then(response => {
            // Update the hours of places with a google_place_id
            var promises = [];
            response.forEach((x) => {
                var hoursObject = {};
                if (x.hasOwnProperty('result')
                    && x.result.hasOwnProperty('opening_hours')
                    && x.result.hasOwnProperty('place_id')
                    && x.result.opening_hours.hasOwnProperty('weekday_text')) {

                    var hours = x.result.opening_hours.weekday_text;
                    var hours_detail = x.result.opening_hours.periods;
                    var google_place_id = x.result.place_id;
                    var place_id = getKeyByValue(placesToUpdate, google_place_id);

                    promises.push(
                        firebase.firestore().collection(placesFirestoreCollection).doc(place_id)
                            .update({
                                'hours': {
                                    sunday: hours[6].replace("Sunday: ", ""),
                                    monday: hours[0].replace("Monday: ", ""),
                                    tuesday: hours[1].replace("Tuesday: ", ""),
                                    wednesday: hours[2].replace("Wednesday: ", ""),
                                    thursday: hours[3].replace("Thursday: ", ""),
                                    friday: hours[4].replace("Friday: ", ""),
                                    saturday: hours[5].replace("Saturday: ", ""),
                                },
                                'hours_detail': hours_detail,
                            })

                    );
                    console.log("Updating hours for " + place_id);

                } else if (x.hasOwnProperty('result')
                    && x.result.hasOwnProperty('place_id')) {
                    google_place_id = x.result.place_id;
                    place_id = getKeyByValue(placesToUpdate, google_place_id);

                    console.warn("Problem updating hours for " + place_id);
                } else {
                    console.warn("Problem updating a place");
                }
            });
            return Promise.all(promises);
        }).then(result => {
            console.log("Hours Updated!");
            return true;
        }).catch(error => {
            // API call failed...
            console.error("Error: " + error);
        });
})

function getKeyByValue(object, value) {
    return Object.keys(object).find(key => object[key] === value);
}