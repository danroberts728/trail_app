import 'package:alabama_beer_trail/util/const.dart';
import 'package:flutter/material.dart';

class TrailPlaceHours extends StatelessWidget {
  final Map<String, String> hours;

  const TrailPlaceHours({Key key, this.hours}) : super(key: key);

  static List<String> _orderedDays = 
    ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday',];

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

    if(hours == null || hours.length == 0) {
      return retval;
    }

    _orderedDays.forEach(
      (day) {
        retval.add(
          Visibility(
            visible: true,
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(day.toUpperCase(),
                    style: TextStyle(
                      color: Constants.colors.first,
                      fontSize: 18.0,
                      height: 1.4,
                      fontWeight: FontWeight.bold
                    ),
                  ),                  
                ),
                Expanded(
                  flex: 1,
                  child: Text(hours[day].toUpperCase(),                  
                    style: TextStyle(
                      fontSize: 18.0,
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
