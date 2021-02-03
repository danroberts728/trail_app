// Copyright (c) 2021, Fermented Software.
import 'package:beer_trail_app/widgets/trail_passport.dart';
import 'package:flutter/material.dart';

/// The passport screen
class ScreenPassport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Passport"),
      ),
      body: TrailPassport(),
    );
  }
}
