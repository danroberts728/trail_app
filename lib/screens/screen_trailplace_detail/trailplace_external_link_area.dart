// Copyright (c) 2020, Fermented Software.
import 'package:beer_trail_app/util/trail_app_settings.dart';
import 'package:flutter/material.dart';

const double _defaultIconSize = 26.0;

/// An area with an external link for the trail place screen
class TrailPlaceExternalLinkArea extends StatelessWidget {
  final IconData leadingIconData;
  final double leadingIconSize;
  final Widget content;
  final Function onPress;

  const TrailPlaceExternalLinkArea({
    Key key,
    this.leadingIconData,
    this.content,
    this.onPress,
    this.leadingIconSize = _defaultIconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: <Widget>[
            Icon(
              leadingIconData,
              size: leadingIconSize,
              color: TrailAppSettings.subHeadingColor,
            ),
            SizedBox(
              width: 14.0 + (_defaultIconSize - leadingIconSize),
            ),
            Flexible(
              flex: 6,
              fit: FlexFit.tight,
              child: content,
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.exit_to_app_outlined,
                color: TrailAppSettings.actionLinksColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
