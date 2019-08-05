import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'util/appauth.dart';
import 'util/const.dart';
import 'widgets/home.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(TrailApp());
  });
}

class TrailApp extends StatelessWidget {

  TrailApp() {
    AppAuth();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.strings.appName,
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        primarySwatch: Constants.colors.themePrimarySwatch,
      ),
      home: Home( ),
    );
  }
}
