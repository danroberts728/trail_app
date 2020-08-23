import 'package:flutter/material.dart';

class CheckInCountWidget extends StatelessWidget {
  final int count;
  final bool visible;
  final IconData icon;
  final double fontSize;
  final double iconSize;
  final Color iconColor;
  final Color fontColor;
  final String overrideTextNoCheckins;
  final String overrideTextOneCheckins;
  final String overrideTextManyCheckins;

  const CheckInCountWidget(
      {Key key,
      @required this.count,
      @required this.visible,
      this.icon = Icons.beenhere,
      this.fontSize = 12.0,
      this.iconSize = 14.0,
      this.iconColor,
      this.fontColor,
      this.overrideTextNoCheckins,
      this.overrideTextOneCheckins,
      this.overrideTextManyCheckins})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String wording =
        this.count == 1 ? "${this.count} check-in" : "${this.count} check-ins";
    if (this.overrideTextNoCheckins != null && this.count == 0) {
      wording = overrideTextNoCheckins;
    }
    if (this.overrideTextOneCheckins != null && this.count == 1) {
      wording = overrideTextOneCheckins.replaceAll("<count>", count.toString());
    }
    if (this.overrideTextManyCheckins != null && this.count > 1) {
      wording =
          overrideTextManyCheckins.replaceAll("<count>", count.toString());
    }

    return Visibility(
      visible: this.visible,
      child: Container(
        padding: EdgeInsets.only(
          left: 10.0,
          top: 4.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              this.icon,
              size: this.iconSize,
              color: this.iconColor,
            ),
            SizedBox(width: 4.0),
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                wording,
                style: TextStyle(
                  fontSize: this.fontSize,
                  color: this.fontColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
