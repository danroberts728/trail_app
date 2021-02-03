// Copyright (c) 2020, Fermented Software.
import 'dart:async';

import 'package:beer_trail_app/blocs/single_trail_event_bloc.dart';
import 'package:beer_trail_app/blocs/single_trail_place_bloc.dart';
import 'package:beer_trail_app/tabscreens/tabscreen_badges.dart';
import 'package:beer_trail_app/util/tabselection_service.dart';
import 'package:beer_trail_app/screens/screen_trailevent_detail.dart';
import 'package:beer_trail_app/screens/screen_trailplace_detail/screen_trailplace_detail.dart';
import 'package:beer_trail_app/tabscreens/tabscreen_events.dart';
import 'package:beer_trail_app/tabscreens/tabscreen_news.dart';
import 'package:beer_trail_app/util/app_launcher.dart';
import 'package:beer_trail_app/util/trail_app_settings.dart';
import 'package:beer_trail_app/widgets/app_drawer.dart';
import 'package:beer_trail_app/widgets/trail_search_delegate.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:beer_trail_app/util/appauth.dart';
import '../tabscreens/tabscreen.dart';

import '../tabscreens/tabscreen_trail.dart';
import 'package:flutter/material.dart';

/// The app home screen
///
/// This controls the scaffold for the tabs
class Home extends StatefulWidget {
  Home({this.observer, this.key});

  @override
  final Key key;

  final FirebaseAnalyticsObserver observer;

  @override
  State<StatefulWidget> createState() => HomeState();
}

/// The state for the home screen
///
class HomeState extends State<Home>
    with SingleTickerProviderStateMixin, RouteAware {
  final _tabSelectionBloc = TabSelectionService();

  HomeState() {
    AppAuth().onAuthChange.listen((event) {
      setState(() {
        _userLoggedIn = event != null;
      });
    });
  }

  /// Firebase Messaging
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  GlobalKey _stackKey = GlobalKey();

  /// The currently-selected tab index
  int _currentIndex = 0;

  /// The app bar title
  ///
  /// This is updated when the [_currentIndex] is changed
  Text _appBarTitle;

  bool _userLoggedIn = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.observer.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPush() {
    _sendCurrentTabToAnalytics();
  }

  @override
  void didPopNext() {
    _sendCurrentTabToAnalytics();
  }

  @override
  void initState() {
    super.initState();
    _appBarTitle =
        Text(_appTabs[_currentIndex].appBarTitle, key: Key("MainAppBarTitle"));
    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
        sound: true,
        badge: true,
        alert: true,
        provisional: true,
      ),
    );
    _firebaseMessaging.configure(
      onMessage: _handleNotificationMessage,
      onLaunch: _handleNotificationLaunch,
      onResume: _handleNotificationResume,
    );
  }

  /// A list of the tabs.
  final List<TabScreen> _appTabs = [
    TabScreen(
      appBarTitle: TrailAppSettings.navBarTrailTabTitle,
      child: TabScreenTrail(),
    ),
    TabScreen(
      appBarTitle: TrailAppSettings.navBarEventsTabTitle,
      child: TabScreenTrailEvents(),
    ),
    TabScreen(
      appBarTitle: TrailAppSettings.navBarNewsTabTitle,
      child: TabScreenNews(),
    ),
    TabScreen(
      appBarTitle: TrailAppSettings.navBarAchievementsTabTitle,
      child: TabScreenBadges(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      drawer: AppDrawer(
        isUserLoggedIn: _userLoggedIn,
      ),
      appBar: AppBar(
        title: Center(child: _appBarTitle),
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
        ],
      ),
      body: IndexedStack(
        key: _stackKey,
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
            label: TrailAppSettings.navBarTrailLabel,
          ),
          BottomNavigationBarItem(
            icon: Icon(TrailAppSettings.navBarEventsIcon),
            label: TrailAppSettings.navBarEventsLabel,
          ),
          BottomNavigationBarItem(
            icon: Icon(TrailAppSettings.navBarNewsIcon),
            label: TrailAppSettings.navBarNewsLabel,
          ),
          BottomNavigationBarItem(
            icon: new Icon(TrailAppSettings.navBarAchievementsIcon),
            label: TrailAppSettings.navBarAchievementsLabel,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.observer.unsubscribe(this);
    super.dispose();
  }

  /// Called when user taps a tab on the bottom
  void _onTabTapped(int index) {
    setState(() {
      if (index != _currentIndex) {
        _currentIndex = index;
        _appBarTitle = Text(_appTabs[index].appBarTitle);
        _sendCurrentTabToAnalytics();
      }
      _tabSelectionBloc.updateTabSelection(index);
    });
  }

  /// Send the current tab selection to analytics
  void _sendCurrentTabToAnalytics() {
    widget.observer.analytics.setCurrentScreen(
      screenName: 'tab/$_currentIndex',
    );
  }

  Future _handleNotificationLaunch(Map<String, dynamic> message) {
    return _navigateNotificationRoute(message);
  }

  Future _handleNotificationMessage(Map<String, dynamic> message) {
    return _showNotificationSnackBar(message);
  }

  Future _handleNotificationResume(Map<String, dynamic> message) {
    return _navigateNotificationRoute(message);
  }

  Future<void> _showNotificationSnackBar(Map<dynamic, dynamic> message) async {
    var data = message['data'] ?? message;
    String gotoPlace = data['gotoPlace'];
    String gotoEvent = data['gotoEvent'];
    String gotoLink = data['gotoLink'];
    String title = message['notification']['title'];

    if (gotoPlace != null) {
      SingleTrailPlaceBloc trailPlaceBloc = SingleTrailPlaceBloc(gotoPlace);
      trailPlaceBloc.trailPlaceStream.listen((place) {        
        Scaffold.of(_stackKey.currentContext).showSnackBar(SnackBar(
          content: Text(title),
          duration: Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Go',
            textColor: TrailAppSettings.actionLinksColor,
            onPressed: () {
              Navigator.of(_stackKey.currentContext)
                  .popUntil((route) => route.isFirst);
              Navigator.push(
                  _stackKey.currentContext,
                  MaterialPageRoute(
                      settings: RouteSettings(
                        name: '/place/$gotoPlace',
                      ),
                      builder: (context) =>
                          TrailPlaceDetailScreen(place: place)));
            },
          ),
        ));
      });
    } else if (gotoEvent != null) {
      SingleTrailEventBloc trailEventBloc = SingleTrailEventBloc(gotoEvent);
      trailEventBloc.trailEventStream.listen((event) {
        Scaffold.of(_stackKey.currentContext).showSnackBar(SnackBar(
          content: Text(title),
          duration: Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Go',
            textColor: TrailAppSettings.actionLinksColor,
            onPressed: () {
              Navigator.of(_stackKey.currentContext)
                  .popUntil((route) => route.isFirst);
              Navigator.push(
                  _stackKey.currentContext,
                  MaterialPageRoute(
                      settings: RouteSettings(
                        name: '/event/$gotoEvent',
                      ),
                      builder: (context) =>
                          TrailEventDetailScreen(event: event)));
            },
          ),
        ));
      });
    } else if (gotoLink != null) {
      Scaffold.of(_stackKey.currentContext).showSnackBar(SnackBar(
        content: Text(title),
        duration: Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Go',
          textColor: TrailAppSettings.actionLinksColor,
          onPressed: () {
            AppLauncher().openWebsite(gotoLink);
          },
        ),
      ));
    }
  }

  Future<void> _navigateNotificationRoute(Map<dynamic, dynamic> message) async {
    var data = message['data'] ?? message;
    String gotoPlace = data['gotoPlace'];
    String gotoEvent = data['gotoEvent'];
    String gotoLink = data['gotoLink'];

    if (gotoPlace != null) {
      SingleTrailPlaceBloc trailPlaceBloc = SingleTrailPlaceBloc(gotoPlace);
      trailPlaceBloc.trailPlaceStream.listen((place) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.push(
            context,
            MaterialPageRoute(
                settings: RouteSettings(
                  name: '/place/$gotoPlace',
                ),
                builder: (context) => TrailPlaceDetailScreen(place: place)));
      });
    } else if (gotoEvent != null) {
      SingleTrailEventBloc trailEventBloc = SingleTrailEventBloc(gotoEvent);
      trailEventBloc.trailEventStream.listen((event) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.push(
            context,
            MaterialPageRoute(
                settings: RouteSettings(
                  name: '/event/$gotoEvent',
                ),
                builder: (context) => TrailEventDetailScreen(event: event)));
      });
    } else if (gotoLink != null) {
      AppLauncher().openWebsite(gotoLink);
    }
  }
}

/// A pop menu item
class PopMenuChoice {
  const PopMenuChoice({this.title, this.icon, this.action});

  final String title;
  final IconData icon;
  final Function action;
}
