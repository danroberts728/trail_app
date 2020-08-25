import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AppUser {
  String uid;
  String email;
  bool isAnonymous;
  User _fbUser;

  AppUser({this.uid, this.email});

  AppUser.fromFirebaseUser(User user) {
    if(user == null) {
      return;
    }
    this._fbUser = user;
    this.uid = user.uid;
    this.email = user.email;
    this.isAnonymous = user.isAnonymous;
  }

  String get createdDate {
    return DateFormat("MMM d, y").format(this._fbUser.metadata.creationTime);
  }

}