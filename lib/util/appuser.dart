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

  String get displayName {
    String retval = '';
    for(var i = 0; i < _fbUser.providerData.length; i++) {
      if(_fbUser.providerData[i].displayName != null && _fbUser.providerData[i].displayName != '') {
        retval = _fbUser.providerData[i].displayName;
        break;
      }
    }
    return retval;
  }

  String get profilePhoto {
    String retval = '';
    for(var i = 0; i < _fbUser.providerData.length; i++) {
      if(_fbUser.providerData[i].photoUrl != null && _fbUser.providerData[i].photoUrl != '') {
        retval = _fbUser.providerData[i].photoUrl;
        break;
      }
    }
    return retval;
  }
}