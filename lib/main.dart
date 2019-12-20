import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import 'package:alabama_beer_trail/screens/screen_app_loading.dart';
import 'screens/screen_register.dart';
import 'screens/screen_signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'blocs/appauth_bloc.dart';
import 'screens/home.dart';

void main() {  
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {    
    runApp(TrailApp());
  });
}

class TrailApp extends StatelessWidget {
  final navigatorKey = GlobalKey<NavigatorState>();
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  TrailApp() {
    AppAuth();
  }
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
          textTheme: TextTheme(
            title: TextStyle(color: Colors.white)
          )
        ),
        home: AppLoadingScreen(),
        routes: {
          '/app-loading': (context) => AppLoadingScreen(),
          '/home': (context) => Home(observer),
          '/sign-in': (context) => SigninScreen(),
          '/register': (context) => RegisterScreen(),
        });
  }
}
