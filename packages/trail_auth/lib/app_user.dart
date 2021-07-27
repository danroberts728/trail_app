// Copyright (c) 2020, Fermented Software.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

/// A logged-in user.
class AppUser {
  /// A unique user ID code
  String uid;

  /// The email address for the user
  String email;

  /// Whether the user is an anonymous user
  bool isAnonymous;

  /// The date the user was created.
  String createdDate;

  AppUser({this.uid, this.email, this.isAnonymous, this.createdDate});

  /// Create an AppUser from a firebase user object
  static AppUser fromFirebase(User user) {
    if (user == null) {
      return null;
    } else {
      return AppUser(
          email: user.email,
          uid: user.uid,
          isAnonymous: user.isAnonymous,
          createdDate:
              DateFormat("MMM d, y").format(user.metadata.creationTime));
    }
  }
}
