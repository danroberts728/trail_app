import 'dart:async';

import 'package:alabama_beer_trail/screens/screen_about.dart';
import 'package:alabama_beer_trail/screens/screen_edit_profile.dart';
import 'package:alabama_beer_trail/screens/tabscreen_events.dart';
import 'package:alabama_beer_trail/screens/tabscreen_news.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/widgets/trail_search_delegate.dart';

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

/// The state for the home screen
///
class _HomeState extends State<Home> {
  /// The currently-selected tab index
  int _currentIndex = 0;

  /// The Floating Action Button for the current tab
  FloatingActionButton _floatingActionButton;

  /// The app bar title
  ///
  /// This is updated when the [_currentIndex] is changed
  Text _appBarTitle;

  /// Whether the user is currently signed-in
  bool _isSignedIn = false;

  /// The key for the scaffold
  GlobalKey _scaffoldKey = GlobalKey();

  /// A stream that sends updates to the user's auth/sign-in status
  StreamSubscription _authChangeSubscription;

  @override
  void initState() {
    super.initState();
    _appBarTitle = Text(_appTabs[_currentIndex].appBarTitle);
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

  /// A list of the tabs.
  final List<TabScreen> _appTabs = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      floatingActionButton: _floatingActionButton,
      appBar: AppBar(
        title: _appBarTitle,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: TrailSearchDelegate(),
              );
            },
          ),
          PopupMenuButton<PopMenuChoice>(
            shape: RoundedRectangleBorder(),
            elevation: 3.2,
            onSelected: (choice) => choice.action(),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<PopMenuChoice>(
                  value: PopMenuChoice(
                    title: "About",
                    icon: Icons.question_answer,
                    action: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              settings: RouteSettings(
                                name: 'About',
                              ),
                              builder: (context) => AboutScreen()));
                    },
                  ),
                  child: Container(child: Text("About")),
                ),
                PopupMenuItem<PopMenuChoice>(
                    value: PopMenuChoice(
                      title: "Log Out",
                      icon: Icons.power_settings_new,
                      action: () => AppAuth().logout(),
                    ),
                    child: Container(child: Text("Log Out")))
              ];
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _appTabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTabTapped,
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
              title: Text(TrailAppSettings.navBarNewsLabel)),
          BottomNavigationBarItem(
            icon: new Icon(TrailAppSettings.navBarProfileIcon),
            title: new Text(TrailAppSettings.navBarProfileLabel),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _authChangeSubscription.cancel();
    super.dispose();
  }

  /// Called when user taps a tab on the bottom
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _appBarTitle = Text(_appTabs[index].appBarTitle);
      _sendCurrentTabToAnalytics();
      _setFloatingActionButton();
    });
  }

  void _setFloatingActionButton() {
    if (_currentIndex == 3) {
      // Profile Tab
      _floatingActionButton = FloatingActionButton(
        child: Icon(Icons.edit),
        backgroundColor: TrailAppSettings.third,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              settings: RouteSettings(
                name: 'Edit Profile',
              ),
              builder: (context) => EditProfileScreen(),
            ),
          );
        },
      );
    } else {
      _floatingActionButton = null;
    }
  }

  /// Send the current tab selection to analytics
  void _sendCurrentTabToAnalytics() {
    TrailApp.analytics.setCurrentScreen(
      screenName: 'tab/' + this._currentIndex.toString(),
    );
  }
}

/// A pop menu item
class PopMenuChoice {
  const PopMenuChoice({this.title, this.icon, this.action});

  final String title;
  final IconData icon;
  final Function action;
}
