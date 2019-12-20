import 'dart:async';

import 'package:alabama_beer_trail/data/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'bloc.dart';

class AppAuth extends Bloc {
  static final AppAuth _singleton = AppAuth._internal();

  factory AppAuth() {
    return _singleton;
  }

  AppAuth._internal() {
    this._auth.onAuthStateChanged.listen(this._handleAuthStatusChanged);
  }

  AppUser user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _authStreamController = StreamController<AppUser>();
  Stream<AppUser> get onAuthChange => this._authStreamController.stream;


  void dispose() {
    _authStreamController.close();
  }

  /// Returns whether user is signed in or not
  SigninStatus get signinStatus {
    return this.user == null 
      ? SigninStatus.NOT_SIGNED_IN
      : SigninStatus.SIGNED_IN;
  }

  void _handleAuthStatusChanged(FirebaseUser fbUser) {
    if(fbUser == null) {
      this.user = null;
    }
    else {
      this.user = AppUser.fromFirebaseUser(fbUser);
    }
    
    _authStreamController.add(user);
  }

  /* Public Methods */

  Future<AppAuthReturn> signInWithEmailAndPassword(String email, String password) async {
    FirebaseUser fbUser;
    String errorMessage;

    try {
      fbUser = (await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      )).user;
    }
    catch (e) {
      if (e.code == "ERROR_WRONG_PASSWORD") {
        errorMessage = "Password is invalid.";
      }
      if (e.code == "ERROR_USER_NOT_FOUND") {
        errorMessage = "User not found. You may need to register.";
      }
      if (e.code == "ERROR_USER_DISABLED ") {
        errorMessage = "This user has been disabled.";
      }
      else {
        errorMessage = "Unknown Error.";
      }
    }
    
    if(user != null) {
      this.user = AppUser.fromFirebaseUser(fbUser);
      return AppAuthReturn(success: true, errorMessage: errorMessage, user: this.user );
    }
    else {
      return AppAuthReturn(success: false, errorMessage: errorMessage, user: this.user );
    }
  }

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

  Future<void> logout() {
    return this._auth.signOut();
  }

  Future<AppUser> register(String email, String password) async {
    FirebaseUser user;
    try {
      user = (await _auth.createUserWithEmailAndPassword(
      email: email, 
      password: password )).user;
    }
    catch (e) {
      user = null;
    }
    
    if(user != null) {
      return AppUser.fromFirebaseUser(user);
    }
    else {
      return null;
    }
  }

  void resetPassword(String email) {
    try {
      _auth.sendPasswordResetEmail(email: email);
    } catch(e) {
      throw e;
    }
  }
}

/// User's sign in status
enum SigninStatus { SIGNED_IN, NOT_SIGNED_IN }

class AppAuthReturn {
  final bool success;
  final String errorMessage;
  final AppUser user;

  AppAuthReturn({this.success, this.errorMessage, this.user});
}