import 'package:flutter/material.dart';

class TrailPlaceHours extends StatelessWidget {
  final Map<String, String> hours;

  const TrailPlaceHours({Key key, this.hours}) : super(key: key);

  static List<String> _orderedDays = [
    'sunday',
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: _buildHoursList(),
      ),
    );
  }

  List<Widget> _buildHoursList() {
    List<Widget> retval = List<Widget>();

    if (hours == null || hours.length == 0) {
      return retval;
    }

    _orderedDays.forEach(
      (day) {
        retval.add(
          Visibility(
            visible: true,
            child: Row(
              children: <Widget>[
                Text(
                  day.substring(0, 3).toUpperCase(),
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18.0,
                      height: 1.4,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    hours[day].toUpperCase(),
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black45
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    return retval;
  }
}
