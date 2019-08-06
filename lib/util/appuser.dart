import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  String displayName;
  String uid;
  String email;
  bool isAnonymous;

  AppUser({this.displayName, this.uid, this.email});

  AppUser.fromFirebaseUser(FirebaseUser user) {
    if(user == null) {
      return;
    }
    this.displayName = user.displayName;
    this.uid = user.uid;
    this.email = user.email;
    this.isAnonymous = user.isAnonymous;
  }
}