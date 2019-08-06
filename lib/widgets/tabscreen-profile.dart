import 'dart:async';

import '../util/appauth.dart';
import 'tabscreenchild.dart';

import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter/material.dart';

class TabScreenProfile extends StatefulWidget implements TabScreenChild {
  final _TabScreenProfile _state = _TabScreenProfile();

  List<IconButton> getAppBarActions() {
    return _state.getAppBarActions();
  }

  @override
  State<StatefulWidget> createState() => _state;
}

class _TabScreenProfile extends State<TabScreenProfile> {
  SigninStatus signinStatus = SigninStatus.NOT_SIGNED_IN;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("Log out"),
              onPressed: () {
                AppAuth().logout();
              },
            )
          ],
        ),
      ),
    );
  }

  List<IconButton> getAppBarActions() {
    return List<IconButton>();
  }

  FutureOr onValue(void value) {}
}

class _GoogleSignInSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GoogleSignInSectionState();
}

class _GoogleSignInSectionState extends State<_GoogleSignInSection> {
  bool _success;
  String _userID;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          alignment: Alignment.center,
          child: GoogleSignInButton(
              darkMode: true,
              onPressed: () async {
                AppAuth().signInWithGoogle();
              }),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            _success == null
                ? ''
                : (_success
                    ? 'Successfully signed in, uid: ' + _userID
                    : 'Sign in failed'),
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
