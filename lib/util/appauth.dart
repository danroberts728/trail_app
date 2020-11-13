// Copyright (c) 2020, Fermented Software.
import 'dart:async';
import 'dart:io';

import 'package:alabama_beer_trail/data/app_user.dart';
import 'package:alabama_beer_trail/data/firebase_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:apple_sign_in/apple_sign_in.dart';

/// An abstraction for User/Authentication
class AppAuth {
  /// Singleton Pattern
  static final AppAuth _singleton = AppAuth._internal();

  /// Singleton constructor.
  factory AppAuth() {
    return _singleton;
  }

  /// Singleton pattern private constructor.
  AppAuth._internal() {
    this._auth.authStateChanges().listen(this._handleAuthStatusChanged);
  }

  /// The authenticated user, null if not signed in.
  AppUser user;

  /// The reason for the latest registration failure.
  String registrationUserError;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _authStreamController = StreamController<AppUser>.broadcast();
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

  void _handleAuthStatusChanged(User fbUser) {
    if (fbUser == null) {
      this.user = null;
    } else {
      this.user = FirebaseHelper.appUserfromFirebaseUser(fbUser);
    }

    _authStreamController.add(user);
  }

  /// Sign in user using email and password.
  Future<AppAuthReturn> signInWithEmailAndPassword(
      String email, String password) async {
    User fbUser;
    String errorMessage;

    try {
      fbUser = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
    } catch (e) {
      if (e.code == "ERROR_WRONG_PASSWORD") {
        errorMessage = "Password is invalid.";
      }
      if (e.code == "ERROR_USER_NOT_FOUND") {
        errorMessage = "User not found. You may need to register.";
      }
      if (e.code == "ERROR_USER_DISABLED ") {
        errorMessage = "This user has been disabled.";
      } else {
        errorMessage = "Unknown Error.";
      }
    }

    if (user != null) {
      this.user = FirebaseHelper.appUserfromFirebaseUser(fbUser);
      return AppAuthReturn(
          success: true, errorMessage: errorMessage, user: this.user);
    } else {
      return AppAuthReturn(
          success: false, errorMessage: errorMessage, user: this.user);
    }
  }

  /// Sign in user with Google authentication.
  Future<AppUser> signInWithGoogle() async {
    await _googleSignIn.signOut();
    final GoogleSignInAccount googleUser = await this._googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    User user = _auth.currentUser;

    user = (await this._auth.signInWithCredential(credential)).user;
    assert(user.email != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    if (user != null) {
      this.user = FirebaseHelper.appUserfromFirebaseUser(user);
      print(user.uid);
    }
    return this.user;
  }

  /// Sign in with Apple
  Future<AppAuthReturn> signInWithApple() async {
    if (Platform.isIOS) {
      final AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);
      switch (result.status) {
        case AuthorizationStatus.authorized:
          AppleIdCredential appleIdCredential = result.credential;
          OAuthProvider oAuthProvider = OAuthProvider('apple.com');
          AuthCredential credential = oAuthProvider.credential(
              idToken: String.fromCharCodes(appleIdCredential.identityToken),
              accessToken:
                  String.fromCharCodes(appleIdCredential.authorizationCode));
          UserCredential authResult =
              await FirebaseAuth.instance.signInWithCredential(credential);

          AppUser user = FirebaseHelper.appUserfromFirebaseUser(authResult.user);
          return AppAuthReturn(errorMessage: null, user: user, success: true);
          break;
        case AuthorizationStatus.cancelled:
          return AppAuthReturn(
              errorMessage: "User Canceled", success: false, user: null);
          break;
        case AuthorizationStatus.error:
          return AppAuthReturn(
              errorMessage: result.error.toString(),
              success: false,
              user: null);
          break;
        default:
          return Future.microtask(() => AppAuthReturn(
                errorMessage: "Unknown Error",
                success: false,
                user: null,
              ));
      }
    } else {
      return Future.microtask(() => AppAuthReturn(
          errorMessage: "Not supported", success: false, user: null));
    }
  }

  /// Sign out the user.
  Future<void> logout() {
    return this._auth.signOut();
  }

  /// Register a new user using email and password.
  Future<AppUser> register(String email, String password) async {
    User user;
    try {
      user = (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
    } catch (e) {
      if (e.code == 'email-already-in-use') {
        registrationUserError = "Email already in use";
      } else if (e.code == 'invalid email') {
        registrationUserError = "Invalid email address";
      } else if (e.code == 'operation-not-allowed') {
        registrationUserError = "Server error";
      } else if (e.code == 'weak-password') {
        registrationUserError = "Password not strong enough";
      } else {
        registrationUserError = e.toString();
      }
      user = null;
    }

    if (user != null) {
      return FirebaseHelper.appUserfromFirebaseUser(user);
    } else {
      return null;
    }
  }

  void resetPassword(String email) {
    try {
      _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
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
