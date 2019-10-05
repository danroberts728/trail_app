import 'dart:async';

import 'package:alabama_beer_trail/screens/tabscreen-profile-edit.dart';
import 'package:alabama_beer_trail/widgets/profile-photo.dart';
import '../widgets/profile_stat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  String _bannerImageUrl = AppAuth().user.defaultBannerImageUrl;
  String _profilePhotoUrl = AppAuth().user.defaultProfilePhotoUrl;
  String _displayName = AppAuth().user.defaultDisplayName;
  String _displayEmail = AppAuth().user.email;
  int _totalCheckins = 0;
  int _totalUniqueCheckins = 0;
  int _totalFavorites = 0;
  int _totalNotVisisted = 0;

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
                  image: NetworkImage( this._bannerImageUrl ),
                  fit: BoxFit.cover,
                  colorFilter:
                      ColorFilter.mode(Colors.grey.shade700, BlendMode.darken),
                ),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 16.0),
                  ProfilePhoto(
                    image: NetworkImage( this._profilePhotoUrl ),
                  ),
                  Text(
                    this._displayName,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 22.0,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    this._displayEmail,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.lightGreenAccent,
                    )),
                  SizedBox(height: 16.0),
                ],
              ),
            ),
            ProfileStat(
              description: "Favorite Places",
              value: this._totalFavorites,
            ),
            ProfileStat(
              description: "Unique Places Visited",
              value: this._totalUniqueCheckins,
            ),
            ProfileStat(
              description: "Have Not Visisted",
              value: this._totalNotVisisted,
            ),
            ProfileStat(
              description: "Total Check-ins",
              value: this._totalCheckins,
            ),            
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

  @override
  void initState() {
    super.initState();

    Firestore.instance.document('user_data/${AppAuth().user.uid}').snapshots().listen((DocumentSnapshot ds) {
      var userData = ds.data;
      if(userData.containsKey('bannerImageUrl')) {
        setState(() {
          this._bannerImageUrl = ds.data['bannerImageUrl'];
        });        
      }
      if(userData.containsKey('profilePictureUrl')) {
        setState(() {
          this._profilePhotoUrl = ds.data['profilePhotoUrl'];
        });        
      }
      if(userData.containsKey('displayName')) {
        setState(() {
          this._displayName = ds.data['displayName'];
        });        
      }
    });

    AppAuth().user.getTotalUniqueCheckins().then((int result) {
      setState(() {
        this._totalUniqueCheckins = result;
      });      
    });

    AppAuth().user.getTotalCheckins().then((int result) {
      setState(() {
        this._totalCheckins = result;
      });      
    });

    AppAuth().user.getTotalNotVisited().then((int result) {
      setState(() {
       this._totalNotVisisted = result; 
      });
    });

    Firestore.instance.document('user_data/${AppAuth().user.uid}/').snapshots().listen((DocumentSnapshot ds) {
      setState(() {
        this._totalFavorites = ds.data['favorites'].length;
      });      
    });
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
