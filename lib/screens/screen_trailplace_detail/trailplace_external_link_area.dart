import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:flutter/material.dart';

const double _defaultIconSize = 26.0;

class TrailPlaceExternalLinkArea extends StatelessWidget {
  final IconData iconData;
  final Widget content;
  final Function onPress;
  final double iconSize;

  const TrailPlaceExternalLinkArea(
      {Key key, this.iconData, this.content, this.onPress, this.iconSize = _defaultIconSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Icon(
            iconData,
            size: iconSize,
            color: TrailAppSettings.subHeadingColor,
          ),
          SizedBox(
            width: 14.0 + (_defaultIconSize - iconSize),
          ),
          content,
          Spacer(),
          IconButton(
            icon: Icon(
              Icons.arrow_forward,
              color: TrailAppSettings.actionLinksColor,
            ),
            onPressed: () {
              onPress();
            },
          )
        ],
      ),
    );
  }
}
