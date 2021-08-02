// Copyright (c) 2020, Fermented Software.
import 'package:trailtab_badges/trailtab_badges.dart';
import 'package:alabama_beer_trail/util/notification_handler.dart';
import 'package:trail_database/trail_database.dart';
import 'package:trailtab_places/trailtab_places.dart';
import 'package:trailtab_events/trailtab_events.dart';
import 'package:alabama_beer_trail/widget/app_drawer.dart';
import 'package:alabama_beer_trail/widget/trail_search_delegate.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:trail_auth/trail_auth.dart';
import 'package:trailtab_wordpress_news/trailtab_wordpress_news.dart';
import 'tabscreen.dart';

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
  NotificationHandler _notificationHandler =
      NotificationHandler(TrailDatabase());

  HomeState() {
    TrailAuth().onAuthChange.listen((event) {
      setState(() {
        _userLoggedIn = event != null;
      });
    });
  }

  /// Firebase Messaging
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

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
    _firebaseMessaging.requestPermission(
        sound: true,
        badge: true,
        alert: true,
        provisional: true,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) { 
      _notificationHandler.handleNotificationMessage(context, message);
    });
  }

  /// A list of the tabs.
  final List<TabScreen> _appTabs = [
    TabScreen(
      appBarTitle: "Alabama Beer Trail",
      child: TrailTabPlaces(
        minDistanceToCheckIn: 0.15,
        showNonMemberTapList: false,
        membershipLogoAsset: 'assets/images/guild_logo_square_color.png',
      ),
    ),
    TabScreen(
      appBarTitle: "Alabama Beer Events",
      child: TrailTabEvents(
        filterDistanceOptions: [5, 25, 50, 100],
      ),
    ),
    TabScreen(
      appBarTitle: "Alabama Beer Passport",
      child: TrailPassport(),
    ),
    TabScreen(
      appBarTitle: "Alabama Beer News",
      child: TrailTabWordpressNews(
        rssFeed: 'https://freethehops.org/category/app-publish/feed/',
        updateFrequencySeconds: 120,
        readTimeoutSeconds: 115,
        timeoutErrorMessage:
            "We're having a hard time getting the news. It may be a problem with the Internet connection.",
      ),
    ),
    TabScreen(
      appBarTitle: "Badges",
      child: TrailTabBadges(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        backgroundColor: Theme.of(context).primaryColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white70,
        showUnselectedLabels: false,
        showSelectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.location_on),
            label: "Trail",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Events",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "Passport",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rss_feed),
            label: "News",
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.emoji_events),
            label: "Badges",
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
    });
  }

  /// Send the current tab selection to analytics
  void _sendCurrentTabToAnalytics() {
    widget.observer.analytics.setCurrentScreen(
      screenName: 'tab/$_currentIndex',
    );
  }
}
