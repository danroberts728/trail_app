import 'package:alabama_beer_trail/screens/screen_app_loading.dart';

import 'screens/screen_register.dart';
import 'screens/screen_signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'util/appauth.dart';
import 'util/const.dart';
import 'screens/home.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(TrailApp());
  });
}

class TrailApp extends StatelessWidget {
  final navigatorKey = GlobalKey<NavigatorState>();

  TrailApp() {
    AppAuth();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorKey,
        title: Constants.strings.appName,
        debugShowCheckedModeBanner: true,
        theme: ThemeData(
          primarySwatch: Constants.colors.themePrimarySwatch,
        ),
        home: AppLoadingScreen(),
        routes: {
          '/home': (context) => Home(),
          '/sign-in': (context) => SigninScreen(),
          '/register': (context) => RegisterScreen(),
        });
  }
}
