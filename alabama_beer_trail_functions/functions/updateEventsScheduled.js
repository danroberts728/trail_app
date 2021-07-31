const firebase = require('firebase-admin');
const rp = require('request-promise');

// Configuration
const eventsJsonUrl = 'https://freethehops.org/wp-json/eventon/events';
const eventsFirestoreCollection = 'events';

// Update events from the [eventsJsonUrl] to the [eventsFirestoreCollection]
const functions = require('firebase-functions');
exports.updateEventsScheduled = functions.pubsub.schedule('every 12 hours').onRun((context) => {
    const firestore = require('node-firestore-import-export');

    const url = eventsJsonUrl;
    var options = {
        uri: url, // Automatically parses the JSON string in the response
    };

    return rp(options)
        .then(result => {
            const collectionRef = firebase.firestore().collection(eventsFirestoreCollection);
            jsonObject = tryParseJSON(result);
            if (jsonObject === false) {
                console.error("Invalid JSON at " + url);
            } else {
                console.log("JSON Valid!");
                events = jsonObject.events;
            }
            return firestore.firestoreImport(events, collectionRef);
        }).then(result => {
            console.log("Events Updated!");
            // Get the new snapshot
            return firebase.firestore().collection(eventsFirestoreCollection).get();
        }).catch(error => {
            // API call failed...
            console.error("Error: " + error);
            return false;
        });
})

// Try to parse JSON. Return false if unable
function tryParseJSON(jsonString) {
    try {
        var o = JSON.parse(jsonString);

        // Handle non-exception-throwing cases:
        // Neither JSON.parse(false) or JSON.parse(1234) throw errors, hence the type-checking,
        // but... JSON.parse(null) returns null, and typeof null === "object", 
        // so we must check for that, too. Thankfully, null is falsey, so this suffices:
        if (o && typeof o === "object") {
            return o;
        }
    }
    catch (e) {
        return false;
    }
    return false;
}

// Upload image from [url] to Firebase storage
// Update [field] of [docId] in [collection] with the new download URL
async function uploadImage(url, collection, docId, field) {
    if (url.includes('alabama-beer-trail-dab63')) {
        // Appears to already be in firestore
        console.log("Skipping " + url);
        return false;
    }
    const bucket = firebase.storage().bucket();

    const http = require('https');
    const path = require('path');
    const os = require('os');
    const fs = require('fs');

    var filename = url.substring(url.lastIndexOf("/") + 1).split("?")[0];
    var fbPath = 'event_images/' + filename;
    var tmpLocalPath = path.join(os.tmpdir(), filename);

    console.log("Uploading " + filename);

    // Download to tmp dir
    try {
        var file = fs.createWriteStream(tmpLocalPath);
        var request = http.get(url, (response) => {
            response.pipe(file);
            file.on('finish', () => {
                file.close();
                console.log('File downloaded to ' + tmpLocalPath);
                bucket.upload(tmpLocalPath, { destination: fbPath, validation: false })
                    .then(result => {
                        console.log("File uploaded to " + fbPath);
                        return true;
                    }).then(result => {
                        fs.unlinkSync(tmpLocalPath);
                        console.log("Temp file removed: " + fbPath);
                        return true;
                    }).then(result => {
                        var date = new Date();
                        date.setDate(date.getDate() + 6);
                        var month = (1 + date.getMonth()).toString().padStart(2, '0');
                        var day = date.getDate().toString().padStart(2, '0');
                        var year = date.getFullYear();
                        return bucket.file(fbPath).getSignedUrl({
                            action: 'read',
                            expires: month + '-' + day + '-' + year
                        });
                    }).then(signedUrls => {
                        console.log('Updating field ' + field + ' to ' + signedUrls);
                        return firebase.firestore().collection(collection).doc(docId)
                            .update({
                                [field]: signedUrls[0]
                            });
                    }).catch(error => {
                        console.log("Error: " + error);
                        return false;
                    });
            });
        }).on('error', (error) => {
            fs.unlink(tmpLocalPath);
            console.error("Error: " + error);
            return false;
        });
    }
    catch (error) {
        console.error("Error: " + error);
        return false;
    }

    return true;
}