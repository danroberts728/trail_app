import 'dart:async';

import 'package:alabama_beer_trail/screens/edit_profile.dart';
import 'package:alabama_beer_trail/widgets/profile-photo.dart';

import '../util/appauth.dart';
import 'tabscreenchild.dart';

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
            Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/fthglasses.jpg"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.grey.shade700, BlendMode.darken),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 16.0),
                    ProfilePhoto(
                      image: NetworkImage(AppAuth().user.profilePhoto),
                    ),
                    Text(
                      AppAuth().user.displayName,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 22.0,
                        color: Colors.white,
                      ),
                    ),
                    Text(AppAuth().user.email,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.lightGreenAccent,
                        )),
                    SizedBox(height: 16.0),
                  ],
                )),
            RaisedButton(
              child: Text("Log out"),
              color: Colors.green,
              textTheme: ButtonTextTheme.primary,
              padding: EdgeInsets.symmetric(horizontal: 80.0),
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
    return <IconButton>[
      IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EditProfileScreen(userId: AppAuth().user.uid)));
        },
      ),
    ];
  }

  FutureOr onValue(void value) {}
}
