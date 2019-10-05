import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  String uid;
  String email;
  bool isAnonymous;
  FirebaseUser _fbUser;

  AppUser({this.uid, this.email});

  AppUser.fromFirebaseUser(FirebaseUser user) {
    if(user == null) {
      return;
    }
    this._fbUser = user;
    this.uid = user.uid;
    this.email = user.email;
    this.isAnonymous = user.isAnonymous;
  }

  String get defaultBannerImageUrl {
    return 'https://firebasestorage.googleapis.com/v0/b/alabama-beer-trail-dab63.appspot.com/o/userData%2Ffthglasses.jpg?alt=media&token=3339f983-651c-4938-90d6-e0c08fb09a3e';
  }

  String get defaultDisplayName {
    String retval;
    for(var i = 0; i < _fbUser.providerData.length; i++) {
      if(_fbUser.providerData[i].displayName != null && _fbUser.providerData[i].displayName != '') {
        retval = _fbUser.providerData[i].displayName;
        break;
      }
    }
    if(retval == null) {
      // Default system display name
      retval = "Joe Sixpack";
    }
    return retval;
  }

  String get defaultProfilePhotoUrl {
    String retval;
    for(var i = 0; i < _fbUser.providerData.length; i++) {
      if(_fbUser.providerData[i].photoUrl != null && _fbUser.providerData[i].photoUrl != '') {
        retval = _fbUser.providerData[i].photoUrl;
        break;
      }
    }
    if(retval == null) {
      // Default system profile photo url
      return 'https://firebasestorage.googleapis.com/v0/b/alabama-beer-trail-dab63.appspot.com/o/userData%2Fanonymous_user.png?alt=media&token=0581afe8-98df-4c12-b64a-567747253df8';
    }
    return retval;
  }

  Future<int> getTotalCheckins() {
    return Firestore.instance.collection('user_data/${this.uid}/check_ins/').getDocuments().then((QuerySnapshot snapshot) {
      return snapshot.documents.length;
    });
  }

  Future<int> getTotalUniqueCheckins() { 
    return Firestore.instance.collection('user_data/${this.uid}/check_ins/').getDocuments().then((QuerySnapshot snapshot) {
      List<String> uniquePlaces = List<String>();
      snapshot.documents.toList().forEach((f) {
        if(!uniquePlaces.contains(f['place_id'])) {
          uniquePlaces.add(f['place_id']);
        }
      });
      return uniquePlaces.length;
    });
  }

  Future<int> getTotalNotVisited() {
    return this.getTotalUniqueCheckins()
      .then((int visitedCount) {
        return Firestore.instance.collection('places').getDocuments()
          .then((QuerySnapshot qs) {
            return qs.documents.length;
          })
            .then((int totalCount) {
              return totalCount - visitedCount;
            });
      });
  }
}