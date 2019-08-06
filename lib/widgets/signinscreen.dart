import '../util/appauth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class SigninScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Log In"),
        leading: Container(),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            GoogleSignInButton(
              onPressed: () {
                AppAuth().signInWithGoogle();
              }
            )
          ],
        ),
      ),
    );
  }

}