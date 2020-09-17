import 'package:alabama_beer_trail/screens/tabscreen_profile_profile/tabscreen_profile.dart';
import 'package:alabama_beer_trail/screens/tabscreen_profile_sign_in.dart';
import 'package:alabama_beer_trail/util/appauth.dart';
import 'package:flutter/material.dart';

class TabScreenProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabScreenProfile();

}

class _TabScreenProfile extends State<TabScreenProfile> {

  bool _userLoggedIn;

  _TabScreenProfile() {
    _userLoggedIn = AppAuth().user != null;
    AppAuth().onAuthChange.listen((event) {
      setState(() {
        _userLoggedIn = event != null;
      });      
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_userLoggedIn) {
      return TabScreenProfileProfile();
    } else {
      return TabScreenProfileSignIn();
    }
  }

}