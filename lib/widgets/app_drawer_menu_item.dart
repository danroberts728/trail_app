// Copyright (c) 2020, Fermented Software.
import 'package:beer_trail_app/util/trail_app_settings.dart';
import 'package:flutter/material.dart';

/// A menu item for the app's main drawer menu
class AppDrawerMenuItem extends StatelessWidget {
  final IconData iconData;
  final Color iconColor;
  final double iconSize;
  final String name;
  final Color nameColor;
  final double nameSize;
  final void Function() onTap;

  const AppDrawerMenuItem(
      {Key key,
      @required this.iconData,
      @required this.name,
      @required this.onTap,
      this.iconColor = TrailAppSettings.actionLinksColor,
      this.iconSize = 22.0,
      this.nameColor = Colors.black45,
      this.nameSize = 18.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: <Widget>[
            Icon(
              iconData,
              color: iconColor,
              size: iconSize,
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(name,
                style: TextStyle(
                  fontSize: nameSize,
                  color: nameColor,
                )),
          ],
        ),
      ),
    );
  }
}
