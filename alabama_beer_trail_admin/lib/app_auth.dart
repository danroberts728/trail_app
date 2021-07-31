// Copyright (c) 2020, Fermented Software.
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// An abstraction for User/Authentication
class AppAuth {
  FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AppAuth(FirebaseAuth auth) {
    _auth = auth;
  }

  /// Sign in user using email and password.
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    return _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((userCredential) {
          return true;
        })
        .timeout(Duration(seconds: 5),
            onTimeout: () => false);
  }

  /// Sign in user with Google authentication.
  Future<bool> signInWithGoogle() async {
    await _googleSignIn.signOut();
    final GoogleSignInAccount googleUser = await this._googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _auth.signInWithCredential(credential);
    return true;
  }

  /// Sign out the user.
  Future<void> logout() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('is_trail_admin', false);
    return this._auth.signOut();
  }
}