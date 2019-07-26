import 'package:beer_trail_app/widgets/tabscreenchild.dart';
import 'package:flutter/material.dart';

class TabScreen extends StatelessWidget {
  final TabScreenChild child;
  final String appBarTitle;

  TabScreen({this.child, this.appBarTitle});

  List<IconButton> getAppBarActions() {
    return child.getAppBarActions();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: this.child as Widget,
    );
  }

}