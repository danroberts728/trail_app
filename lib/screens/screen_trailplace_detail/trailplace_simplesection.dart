import 'package:flutter/material.dart';

class TrailPlaceSimpleSection extends StatelessWidget {
  final Icon headerIcon;
  final String content;

  const TrailPlaceSimpleSection({Key key, this.headerIcon, this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          headerIcon,
          SizedBox(
            width: 14.0,
          ),
          Text(
            content,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
