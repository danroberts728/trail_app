import 'package:flutter/material.dart';
import 'util/const.dart';
import 'widgets/home.dart';

void main() => runApp(TrailApp());

class TrailApp extends StatelessWidget {
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
