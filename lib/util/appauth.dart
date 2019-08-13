import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import 'appuser.dart';

class AppAuth {

  /* Singleton Pattern */

  static final AppAuth _instance = AppAuth._privateConstructor();
  factory AppAuth() {
    return _instance;
  }
  AppAuth._privateConstructor() {
    this.onAuthChange = _streamController.stream;
    this._auth.onAuthStateChanged.listen(this._handleAuthStatusChanged);
  }
  void dispose() {
    _streamController.close();
  }

  /* Public Properties */

  /// The user of the application
  /// 
  /// Returns null if user is not signed in
  AppUser user;

  /// Returns whether user is signed in or not
  SigninStatus get signinStatus {
    return this.user == null 
      ? SigninStatus.NOT_SIGNED_IN
      : SigninStatus.SIGNED_IN;
  }

  /// Triggers when auth has changed
  Stream<AppUser> onAuthChange;

  /* Private Properties */

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookLogin = FacebookLogin();
  StreamController<AppUser> _streamController =
      StreamController<AppUser>.broadcast();

  /* Private Methods */

  void _handleAuthStatusChanged(FirebaseUser fbUser) {
    if(fbUser == null) {
      this.user = null;
    }
    else {
      this.user = AppUser.fromFirebaseUser(fbUser);
    }
    
    _streamController.add(user);
  }

  /* Public Methods */

  Future<AppUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await this._googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    FirebaseUser user = await this._auth.currentUser();

    user = (await this._auth.signInWithCredential(credential)).user;
    assert(user.email != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    if (user != null) {
      this.user = AppUser.fromFirebaseUser(user);
      print(user.uid);
    }
    return this.user;
  }

  Future<AppUser> signInWithFacebook() async {
    var result = await this._facebookLogin.logInWithReadPermissions(['email','public_profile']);
    
    final AuthCredential credential = FacebookAuthProvider.getCredential(
      accessToken: result.accessToken.token,
    );
    FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    assert(user.email != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    if (user != null) {
      this.user = AppUser.fromFirebaseUser(user);
      print(user.uid);
    }
    return this.user;
  }

  Future<void> logout() {
    return this._auth.signOut();
  }
}

/// User's sign in status
enum SigninStatus { SIGNED_IN, NOT_SIGNED_IN }
