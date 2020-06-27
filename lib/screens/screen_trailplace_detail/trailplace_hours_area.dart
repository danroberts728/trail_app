import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/widgets/expansion_section.dart';
import 'package:flutter/material.dart';

const double _defaultIconSize = 26.0;

class TrailPlaceHoursArea extends StatefulWidget {
  final TrailPlace place;
  final double iconSize;

  const TrailPlaceHoursArea({Key key, this.place, this.iconSize = _defaultIconSize}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TrailPlaceHoursArea();
}

class _TrailPlaceHoursArea extends State<TrailPlaceHoursArea> {
  @override
  Widget build(BuildContext context) {
    return ExpansionSection(
      title: Text(
        "Open Now",
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.black54,
        ),
      ),
      leading: Icon(
        Icons.access_time,
        size: widget.iconSize,
        color: TrailAppSettings.subHeadingColor,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 35.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Sunday 2:00 PM - 9:00 PM"),
            Text("Monday 2:00 PM - 9:00 PM"),
          ],
        ),
      ),
    );
  }
}
