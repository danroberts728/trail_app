import 'package:flutter/material.dart';

class ProfileStat extends StatelessWidget {
  final String description;
  final int value;

  ProfileStat({@required this.description, @required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  this.description,
                  style: TextStyle(fontSize: 18.0),
                ),
                Spacer(),
                Text(
                  this.value.toString(),
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            )
          ],
        ));
  }
}
