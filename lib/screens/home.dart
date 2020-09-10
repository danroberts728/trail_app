import 'dart:async';

import 'package:alabama_beer_trail/blocs/single_trail_event_bloc.dart';
import 'package:alabama_beer_trail/blocs/single_trail_place_bloc.dart';
import 'package:alabama_beer_trail/util/tabselection_service.dart';
import 'package:alabama_beer_trail/screens/screen_about.dart';
import 'package:alabama_beer_trail/screens/screen_edit_profile.dart';
import 'package:alabama_beer_trail/screens/screen_trailevent_detail.dart';
import 'package:alabama_beer_trail/screens/screen_trailplace_detail/screen_trailplace_detail.dart';
import 'package:alabama_beer_trail/screens/tabscreen_events.dart';
import 'package:alabama_beer_trail/screens/tabscreen_news.dart';
import 'package:alabama_beer_trail/util/app_launcher.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/widgets/fab_event_filter.dart';
import 'package:alabama_beer_trail/widgets/event_filter_widget.dart';
import 'package:alabama_beer_trail/widgets/fab_place_filter.dart';
import 'package:alabama_beer_trail/screens/screen_place_filter.dart';
import 'package:alabama_beer_trail/widgets/trail_search_delegate.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../util/appauth.dart';
import '../screens/tabscreen_profile/tabscreen_profile.dart';
import 'tabscreen.dart';

import 'tabscreen_trail.dart';
import 'package:flutter/material.dart';

/// The app home screen
///
/// This controls the scaffold for the tabs
/// and directs the user to the tabs
/// or the sign in screen
class Home extends StatefulWidget {
  Home(this.observer);

  final FirebaseAnalyticsObserver observer;

  @override
  State<StatefulWidget> createState() => _HomeState();
}

/// The state for the home screen
///
class _HomeState extends State<Home>
    with SingleTickerProviderStateMixin, RouteAware {
  final _tabSelectionBloc = TabSelectionService();

  /// Firebase Messaging
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  GlobalKey _stackKey = GlobalKey();

  /// The currently-selected tab index
  int _currentIndex = 0;

  /// The Floating Action Button for the current tab
  FloatingActionButton _floatingActionButton;

  /// The app bar title
  ///
  /// This is updated when the [_currentIndex] is changed
  Text _appBarTitle;

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
    _appBarTitle = Text(_appTabs[_currentIndex].appBarTitle);
    _setFloatingActionButton();
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
      appBarTitle: TrailAppSettings.navBarProfileTabTitle,
      child: TabScreenProfile(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
                    title: "Submit Feedback",
                    icon: Icons.email,
                    action: () {
                      AppLauncher()
                          .openWebsite(TrailAppSettings.submitFeedbackUrl);
                    },
                  ),
                  child: Container(child: Text("Submit Feedback")),
                ),
                PopupMenuItem<PopMenuChoice>(
                  value: PopMenuChoice(
                    title: "Privacy Policy",
                    icon: Icons.info,
                    action: () {
                      AppLauncher()
                          .openWebsite(TrailAppSettings.privacyPolicyUrl);
                    },
                  ),
                  child: Container(child: Text("Privacy Policy")),
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
        _setFloatingActionButton();
      }
      _tabSelectionBloc.updateTabSelection(index);
    });
  }

  void _setFloatingActionButton() {
    if (_currentIndex == 0) {
      // Trail Tab
      _floatingActionButton = FloatingActionButton(
        child: PlaceFilterFab(),
        backgroundColor: TrailAppSettings.actionLinksColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              settings: RouteSettings(
                name: 'Open Filter',
              ),
              builder: (context) => ModalTrailFilter(),
            ),
          );
        },
      );
    } else if (_currentIndex == 1) {
      // Events Tab
      _floatingActionButton = FloatingActionButton(
        child: EventFilterFab(),
        backgroundColor: TrailAppSettings.actionLinksColor,
        onPressed: () => showModalBottomSheet(
            context: context,
            builder: (context) {
              return SingleChildScrollView(
                child: EventFilterWidget(),
              );
            }),
      );
    } else if (_currentIndex == 3) {
      // Profile Tab
      _floatingActionButton = FloatingActionButton(
        child: Icon(Icons.edit),
        backgroundColor: TrailAppSettings.actionLinksColor,
        foregroundColor: Colors.white70,
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
