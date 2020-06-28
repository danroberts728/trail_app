import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:flutter/material.dart';

const double _defaultIconSize = 26.0;

class TrailPlaceExternalLinkArea extends StatelessWidget {
  final IconData leadingIconData;
  final double leadingIconSize;
  final IconData trailingIconData;
  final double trailingIconSize;
  final Widget content;
  final Function onPress;

  const TrailPlaceExternalLinkArea(
      {Key key,
      this.leadingIconData,
      this.content,
      this.onPress,
      this.leadingIconSize = _defaultIconSize,
      this.trailingIconData,
      this.trailingIconSize = _defaultIconSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
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
            content,
            Spacer(),
            IconButton(
              icon: Icon(
                trailingIconData,
                size: trailingIconSize,
                color: TrailAppSettings.actionLinksColor,
              ),
              onPressed: () {
                onPress();
              },
            )
          ],
        ),
      ),
    );
  }
}
