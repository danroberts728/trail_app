// Copyright (c) 2020, Fermented Software.

library trail_auth;
export 'app_user.dart';
export './widget/screen_forgot_password.dart';
export './widget/screen_register.dart';
export './widget/screen_sign_in.dart';

import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:trail_auth/app_user.dart';

/// Trail Authentication helper class
class TrailAuth {
  /// Singleton Pattern
  static final TrailAuth _singleton = TrailAuth._internal();

  /// Singleton constructor.
  factory TrailAuth() {
    return _singleton;
  }

  /// Singleton pattern private constructor.
  TrailAuth._internal() {
    this._auth.authStateChanges().listen(this._handleAuthStatusChanged);
  }

  /// The authenticated user.
  /// If the user is not signed in, this returns null
  AppUser user;

  /// The reason for the latest registration failure.
  String registrationUserError;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _authStreamController = StreamController<AppUser>.broadcast();
  Stream<AppUser> get onAuthChange => this._authStreamController.stream;

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
      this.user = AppUser.fromFirebase(fbUser);
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
      this.user = AppUser.fromFirebase(fbUser);
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
      this.user = AppUser.fromFirebase(user);
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

          AppUser user = AppUser.fromFirebase(authResult.user);
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
      return AppUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  /// Initiate a reset password request for the user with [email]
  void resetPassword(String email) {
    try {
      _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw e;
    }
  }

  void dispose() {
    _authStreamController.close();
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
