const firebase = require('firebase-admin');
const rp = require('request-promise');

// Configuration
const placesFirestoreCollection = 'places';
const last_update_field = 'last_all_beers_update';

// Get Untappd Beer List
const functions = require('firebase-functions');
exports.addLastUpdateOnRequest = functions.https.onRequest(
    (context) => {
        return firebase.firestore().collection(placesFirestoreCollection)
            .get()
            .then(querySnapshot => {
                var promises = []
                // Add 'last_all_beers_update' if null
                querySnapshot.forEach(doc => {
                    var data = doc.data();
                    if (!data.hasOwnProperty(last_update_field)) {
                        promises.push(
                            firebase.firestore().collection(placesFirestoreCollection).doc(doc.id)
                                .update({
                                    last_all_beers_update: firebase.firestore.Timestamp.now()
                                })
                        );
                    }
                });
                return true;
            });
    });