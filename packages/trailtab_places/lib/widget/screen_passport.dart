// Copyright (c) 2021, Fermented Software.
import 'package:trailtab_places/trailtab_places.dart';
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
