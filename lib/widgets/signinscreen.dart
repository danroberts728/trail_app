import '../util/appuser.dart';

import '../util/appauth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class SigninScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppAuth().onAuthChange.listen((AppUser result) {
      if (result != null) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: Container(
        color: Colors.amberAccent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 40.0,
              ),
              GoogleSignInButton(
                onPressed: () {
                  AppAuth().signInWithGoogle();
                },
                borderRadius: 10.0,
                darkMode: true,
              ),
              SizedBox(
                height: 20.0,
              ),
              FacebookSignInButton(
                onPressed: () {},
                text: "Sign in with Facebook",
                borderRadius: 10.0,
              ),
              SizedBox(
                height: 20.0,
              ),
              TwitterSignInButton(
                onPressed: () {},
                borderRadius: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
