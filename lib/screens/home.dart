import 'dart:async';

import '../util/appauth.dart';
import 'tabscreen-profile.dart';
import 'tabscreen.dart';

import 'tabscreen-trail.dart';
import 'package:flutter/material.dart';
import '../util/const.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  Text _appBarTitle;
  List<IconButton> _appBarActions;
  bool _isSignedIn = false;
  GlobalKey _scaffoldKey = GlobalKey();
  StreamSubscription _authChangeSubscription;

  _HomeState() {
    _appBarTitle = Text(_children[_currentIndex].appBarTitle);
    _appBarActions = _children[_currentIndex].getAppBarActions();
  }

  @override
  void initState() {
    super.initState();
    _authChangeSubscription = AppAuth().onAuthChange.listen((user) {
      this._isSignedIn = user != null;
      if (!this._isSignedIn) {
        try {
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
      child: TabScreenTrail(),
      appBarTitle: Constants.strings.navBarTrailTabTitle,
    ),
    TabScreen(
      child: TabScreenProfile(),
      appBarTitle: Constants.strings.navBarProfileTabTitle,
    ),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _appBarTitle = Text(_children[index].appBarTitle);
      _appBarActions = _children[index].getAppBarActions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: _appBarTitle,
        actions: _appBarActions,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        backgroundColor: Constants.colors.navBarBackgroundColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Constants.colors.navBarSelectedItemColor,
        showUnselectedLabels: Constants.options.navBarShowUnselectedLabels,
        showSelectedLabels: Constants.options.navBarShowSelectedLabels,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Constants.icons.navBarTrailIcon),
            title: new Text(Constants.strings.navBarTrailLabel),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Constants.icons.navBarProfileIcon),
            title: new Text(Constants.strings.navBarProfileLabel),
          ),
        ],
      ),
    );
  }
}
