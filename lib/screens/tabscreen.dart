import 'package:flutter/material.dart';

class TabScreen extends StatelessWidget {
  final Widget child;
  final String appBarTitle;
  final FloatingActionButton floatingActionButton;

  TabScreen({this.child, this.appBarTitle, this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: this.child,
    );
  }

}