import 'package:flutter/material.dart';

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