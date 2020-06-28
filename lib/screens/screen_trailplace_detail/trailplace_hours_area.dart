import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/widgets/expansion_section.dart';
import 'package:flutter/material.dart';

const double _defaultIconSize = 26.0;

const List<String> _weekdays = [
  'filler',
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday',
  'saturday',
  'sunday'
];

DateTime _now = DateTime.now().toLocal();
String _nowDay = _weekdays[_now.weekday];

class TrailPlaceHoursArea extends StatefulWidget {
  final TrailPlace place;
  final double iconSize;

  const TrailPlaceHoursArea(
      {Key key, this.place, this.iconSize = _defaultIconSize})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TrailPlaceHoursArea();
}

class _TrailPlaceHoursArea extends State<TrailPlaceHoursArea> {
  Text _status;

  @override
  void initState() {
    super.initState();
    setState(() {
      _status = _getStatusString(widget.place.hours);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionSection(
      title: _status,
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
          children: [
            'sunday',
            'monday',
            'tuesday',
            'wednesday',
            'thursday',
            'friday',
            'saturday'
          ].map((key) {
            return Row(
              children: <Widget>[
                Text(
                  key[0].toUpperCase() + key.substring(1) + ": ",
                  style: TextStyle(
                    fontSize: 16.0,
                    height: 1.5,
                    color: key == _nowDay
                      ? Colors.green
                      : Colors.black,
                  ),
                ),
                Spacer(),
                Text(
                  widget.place.hours[key],
                  style: TextStyle(
                    fontSize: 16.0,
                    height: 1.5,
                    color: key == _nowDay
                      ? Colors.green
                      : Colors.black,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

Text _getStatusString(Map<String, String> hours) {
  String status = "Closed today";
  Color statusColor = Colors.red;

  if (hours[_nowDay].toLowerCase() == "closed") {
    status = "Closed Today";
    statusColor = Colors.red;
  } else {
    status = "Open Today " + hours[_nowDay];
    statusColor = Colors.green;
  }

  return Text(
    status,
    style: TextStyle(
      fontSize: 14.0,
      color: statusColor,
    ),
  );
}
