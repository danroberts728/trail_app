import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:flutter/material.dart';

class ProfileStat extends StatelessWidget {
  final String postText;
  final int value;
  final Function onPressed;

  ProfileStat(
      {@required this.postText,
      @required this.value,
      @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: this.onPressed,
      child: RichText(
        text: TextSpan(
          text: this.value.toString() ?? '-',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
          children: <TextSpan> [
            TextSpan(
              text: " ${this.postText}",
              style: TextStyle(
                color: TrailAppSettings.actionLinksColor,
                fontSize: 16.0,
              ),
            ),
          ]
        ),
      ),
    );
  }
}
