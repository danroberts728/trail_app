const assert = require('assert');
const firebase = require('@firebase/testing');

const PROJECT_ID = 'alabama-beer-trail-dab63';

describe("Alabama Beer Trail Functions", () => {
    it("Understands basic math", () => {
        assert(2+2, 4);
    });

    it("Can read places", async() => {
        const db = firebase.initializeTestApp({projectId: PROJECT_ID}).firestore();
        const testDoc = db.collection('places').doc('avondale');
        await firebase.assertSucceeds(testDoc.get());
    });
})