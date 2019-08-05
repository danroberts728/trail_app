import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AppAuth {
  static final AppAuth _instance =
      AppAuth._privateConstructor();
  factory AppAuth() {
    return _instance;
  }

  AppAuth._privateConstructor();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String userId;
  SigninStatus signinStatus = SigninStatus.NOT_SIGNED_IN;

  Future<String> signInAnonymously() async {
    final FirebaseUser user = (await _auth.signInAnonymously()).user;
    assert(user != null);
    assert(user.isAnonymous);
    assert(!user.isEmailVerified);
    assert(await user.getIdToken() != null);
    if (Platform.isIOS) {
      // Anonymous auth doesn't show up as a provider on iOS
      assert(user.providerData.isEmpty);
    } else if (Platform.isAndroid) {
      // Anonymous auth does show up as a provider on Android
      assert(user.providerData.length == 1);
      assert(user.providerData[0].providerId == 'firebase');
      assert(user.providerData[0].uid != null);
      assert(user.providerData[0].displayName == null || user.providerData[0].displayName == '');
      assert(user.providerData[0].photoUrl == null);
      assert(user.providerData[0].email == null || user.providerData[0].displayName == '');
    }

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    if (user != null) {
      this.signinStatus = SigninStatus.ANONYMOUS;
      this.userId = user.uid;
    } 
    else {
      this.signinStatus = SigninStatus.NOT_SIGNED_IN;
    }
    return user.uid;
  }

Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await this._googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    FirebaseUser user = await this._auth.currentUser();

    if(user != null && this.signinStatus == SigninStatus.ANONYMOUS) {
      await user.linkWithCredential(credential);
    }

    user = (await this._auth.signInWithCredential(credential)).user;
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    if (user != null) {
      this.signinStatus = SigninStatus.SIGNED_IN;
      this.userId = user.uid;
      print(user.uid);
    } else {
      this.signinStatus = SigninStatus.NOT_SIGNED_IN;
    }
    return this.userId;
  }
}

enum SigninStatus {
  SIGNED_IN,
  ANONYMOUS,
  NOT_SIGNED_IN
}