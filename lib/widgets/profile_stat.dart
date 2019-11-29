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
      child: Row(
        children: <Widget>[
          Text(
            "${this.value ?? '-'}",
            overflow: TextOverflow.fade,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16.0),
          ),
          Text(
            " ${this.postText}",
            overflow: TextOverflow.fade,
            style: TextStyle(
              color: TrailAppSettings.actionLinksColor,
              fontSize: 16.0
            ),
          ),
        ],
      ),
    );
  }
}
