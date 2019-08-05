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
    if (AppAuth().signinStatus == SigninStatus.NOT_SIGNED_IN) {
      AppAuth().signInAnonymously().then((userId) {
        return this._buildScreen();
      });
    } else {
      return this._buildScreen();
    }
    return Container();
  }

  List<IconButton> getAppBarActions() {
    return List<IconButton>();
  }

  Widget _buildScreen() {
    switch (this.signinStatus) {
      case SigninStatus.SIGNED_IN:
        return _buildProfileScreen();
      default:
        return _buildSigninScreen();
    }
  }

  Widget _buildSigninScreen() {
    return Container(
        child: Column(
      children: <Widget>[
        SizedBox(
          height: 12.0,
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
            child: Text(
              "Sign in for full features",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _GoogleSignInSection(),
            ],
          )
        )        
      ],
    ));
  }

  Widget _buildProfileScreen() {
    return Container();
  }
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
