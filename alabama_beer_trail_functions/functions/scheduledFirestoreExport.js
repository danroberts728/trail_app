const firebase = require('firebase-admin');

// Scheduled daily backup
const functions = require('firebase-functions');
exports.scheduledFirestoreExport = functions.pubsub
    .schedule('every 24 hours')
    .onRun((context) => {
        const firestore = require('node-firestore-import-export');
        const path = require('path');
        const os = require('os');
        const fs = require('fs');

        return firebase.firestore().listCollections()
            .then(collectionRefs => {
                var promises = [];
                collectionRefs.forEach(ref => {
                    promises.push(firestore.firestoreExport(ref));
                })
                return Promise.all(promises);
            })
            .then(results => {      
                var i = 0;                
                results.forEach(result => { 
                    i++;        
                    var jsonObject = JSON.stringify(result)      ;
                    if (jsonObject === false) {
                        console.error("Invalid JSON");
                        return false;
                    } else {
                        console.log("JSON Valid!");
                        var now = new Date();
                        var backupFileName = i.toString() + '-' +
                            now.getYear() + '-' + now.getMonth() + '-' +now.getDate() + ".json";
                        
                        var tmpLocalPath = path.join(os.tmpdir(), backupFileName);
                        fs.writeFileSync(tmpLocalPath, jsonObject);

                        var bucket = firebase.storage().bucket();
                        var backupFile = 'backups/' + backupFileName;
                        bucket.upload(tmpLocalPath, { destination: backupFile, validation: false });
                        console.log("uploading " + backupFile);
                    }
                    return true;
                });
                return true;           
            });
    });