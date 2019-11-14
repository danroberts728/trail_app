import 'dart:async';

import 'package:alabama_beer_trail/screens/tabscreen_events.dart';
import 'package:alabama_beer_trail/screens/tabscreen_news.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';

import '../main.dart';
import '../blocs/appauth_bloc.dart';
import 'tabscreen_profile.dart';
import 'tabscreen.dart';

import 'tabscreen_trail.dart';
import 'package:flutter/material.dart';

/// The app home screen
/// 
/// This controls the scaffold for the tabs
/// and directs the user to the tabs
/// or the sign in screen
class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  Text _appBarTitle;
  bool _isSignedIn = false;
  GlobalKey _scaffoldKey = GlobalKey();
  StreamSubscription _authChangeSubscription;

  @override
  void initState() {
    super.initState();
    _appBarTitle = Text(_children[_currentIndex].appBarTitle);
    _authChangeSubscription = AppAuth().onAuthChange.listen((user) {
      this._isSignedIn = user != null;
      if (!this._isSignedIn) {
        try {
          Navigator.of(_scaffoldKey.currentContext)
              .popUntil((route) => route.isFirst);
          Navigator.of(_scaffoldKey.currentContext)
              .pushReplacementNamed('/sign-in');
        } on FlutterError catch (e) {
          print("Caught Exception in _handleAuthChange: $e");
        }
      }
    });
  }

  @override
  void dispose() {
    _authChangeSubscription.cancel();
    super.dispose();
  }

  final List<TabScreen> _children = [
    TabScreen(
      appBarTitle: TrailAppSettings.navBarTrailTabTitle,
      child: TabScreenTrail(),
    ),
    TabScreen(
      appBarTitle: TrailAppSettings.navBarEventsTabTitle,
      child: TabScreenEvents(),
    ),
    TabScreen(
      appBarTitle: TrailAppSettings.navBarNewsTabTitle,
      child: TabScreenNews(),
    ),
    TabScreen(
      appBarTitle: TrailAppSettings.navBarProfileTabTitle,
      child: TabScreenProfile(),
    ),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _appBarTitle = Text(_children[index].appBarTitle);
      _sendCurrentTabToAnalytics();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: _appBarTitle,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {

            },
          )
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        backgroundColor: TrailAppSettings.navBarBackgroundColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: TrailAppSettings.navBarSelectedItemColor,
        showUnselectedLabels: TrailAppSettings.navBarShowUnselectedLabels,
        showSelectedLabels: TrailAppSettings.navBarShowSelectedLabels,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(TrailAppSettings.navBarTrailIcon),
            title: new Text(TrailAppSettings.navBarTrailLabel),
          ),
          BottomNavigationBarItem(
            icon: Icon(TrailAppSettings.navBarEventsIcon),
            title: Text(TrailAppSettings.navBarEventsLabel),
          ),
          BottomNavigationBarItem(
            icon: Icon(TrailAppSettings.navBarNewsIcon),
            title: Text(TrailAppSettings.navBarNewsLabel)
          ),
          BottomNavigationBarItem(
            icon: new Icon(TrailAppSettings.navBarProfileIcon),
            title: new Text(TrailAppSettings.navBarProfileLabel),
          ),
        ],
      ),
    );
  }

  void _sendCurrentTabToAnalytics() {
    TrailApp.analytics.setCurrentScreen(
      screenName: 'tab/' + this._currentIndex.toString(),
    );
  }
}
