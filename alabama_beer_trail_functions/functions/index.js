const firebase = require('firebase-admin');
firebase.initializeApp();

// Scheduled daily backup
const scheduledFirestoreExport = require('./scheduledFirestoreExport');
// Update times
const updateHoursScheduled = require('./updateHoursScheduled');
// Update events from the [eventsJsonUrl] to the [eventsFirestoreCollection]
const updateEventsScheduled = require('./updateEventsScheduled');
// Update all beers from Untappd
const updateAllBeersScheduled = require('./updateAllBeersScheduled');
// New Update on tap list from alabama.beer
const updateOnTapSmartScheduled = require('./updateOnTapSmartScheduled');
// Add last update field to places
const addLastUpdateOnRequest = require('./addLastUpdateOnRequest');

exports.scheduledFirestoreExport = scheduledFirestoreExport.scheduledFirestoreExport;
exports.updateHoursScheduled = updateHoursScheduled.updateHoursScheduled;
exports.updateEventsScheduled = updateEventsScheduled.updateEventsScheduled;
exports.updateAllBeersScheduled = updateAllBeersScheduled.updateAllBeersScheduled;
exports.updateOnTapSmartScheduled = updateOnTapSmartScheduled.updateOnTapSmartScheduled;
exports.addLastUpdateOnRequest = addLastUpdateOnRequest;