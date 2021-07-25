// Copyright (c) 2020, Fermented Software.
import 'package:alabama_beer_trail/default_theme.dart';
import 'package:trail_database/trail_database.dart';
import 'package:trail_location_service/trail_location_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:trail_auth/trail_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widget/home.dart';


/// The main function for the app
/// 
/// Initialize Widgets, set up Crashlytics,
/// Force landscape mode, get user location,
/// then run the app.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((app) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    return SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]);
  }).then((_) {
    return TrailLocationService().refreshLocation();
  }).then((location) {
    runApp(TrailApp());
  });
}

/// The main app object
/// 
/// Set up analytics. Get FCM token
/// when auth changes, return the material
/// app 
class TrailApp extends StatelessWidget {
  final navigatorKey = GlobalKey<NavigatorState>();
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  // The root of the app
  @override
  Widget build(BuildContext context) {
    TrailAuth().onAuthChange.listen((event) {
      if (TrailAuth().user != null && TrailAuth().user.uid.isNotEmpty) {
        FirebaseMessaging.instance.getToken().then((token) {
          TrailDatabase().saveFcmToken(token);
        });
      }
    });
    return MaterialApp(
      navigatorObservers: <NavigatorObserver>[observer],
      navigatorKey: navigatorKey,
      title: "Alabama Beer Trail",
      debugShowCheckedModeBanner: true,
      theme: defaultTheme,
      home: Home(
        observer: observer,
        key: Key('home'),
      ),
    );
  }
}
