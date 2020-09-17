import 'package:alabama_beer_trail/screens/tabscreen_profile_sign_in.dart';
import 'package:flutter/material.dart';

class ScreenSignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: TabScreenProfileSignIn(),
    );
  }
}
