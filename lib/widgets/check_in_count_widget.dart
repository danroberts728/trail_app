// Copyright (c) 2020, Fermented Software.
import 'package:flutter/material.dart';

class CheckInCountWidget extends StatelessWidget {
  final int count;
  final bool visible;
  final IconData icon;
  final double fontSize;
  final double iconSize;
  final Color iconColor;
  final Color fontColor;

  const CheckInCountWidget(
      {Key key,
      @required this.count,
      @required this.visible,
      this.icon = Icons.beenhere,
      this.fontSize = 12.0,
      this.iconSize = 14.0,
      this.iconColor,
      this.fontColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String wording = "You have no check-ins";
    if(count == 1) {
      wording = "You have $count check-in";
    } else if (count > 1) {
      wording = "You have $count check-ins"; 
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
