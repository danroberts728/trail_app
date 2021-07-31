// Copyright (c) 2020, Fermented Software.
import 'package:flutter/material.dart';

/// A tabscreen for the trail app
/// [child] is the actual screen
/// [appBarTitle] is the text to put in the title bar
class TabScreen extends StatelessWidget {
  final Widget child;
  final String appBarTitle;

  TabScreen({this.child, this.appBarTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: this.child,
    );
  }
}
