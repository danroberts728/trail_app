import 'package:alabama_beer_trail/screens/screen_app_loading.dart';
import 'package:alabama_beer_trail/util/location_service.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'util/appauth.dart';
import 'data/app_user.dart';
import 'screens/screen_signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home.dart';

void main() {
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    return Firebase.initializeApp();
  }).then((fbApp) {
    LocationService().refreshLocation().then((_) {
      runApp(TrailApp());
    });
  });
}

class TrailApp extends StatelessWidget {
  final navigatorKey = GlobalKey<NavigatorState>();
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: <NavigatorObserver>[observer],
      navigatorKey: navigatorKey,
      title: TrailAppSettings.appName,
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
          primarySwatch: TrailAppSettings.themePrimarySwatch,
          hintColor: Colors.white,
          textTheme: TextTheme(headline6: TextStyle(color: Colors.white))),
      home: StreamBuilder<AppUser>(
        initialData: null,
        stream: AppAuth().onAuthChange,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return AppLoadingScreen();
          } else if (snapshot.data == null) {
            return SigninScreen();
          } else {
            return Home(observer);
          }
        },
      ),
    );
  }
}
