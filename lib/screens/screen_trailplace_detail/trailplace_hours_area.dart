import 'package:alabama_beer_trail/blocs/trailplace_hours_area_bloc.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/util/open_hours_methods.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/widgets/expansion_section.dart';
import 'package:flutter/material.dart';

class TrailPlaceHoursArea extends StatefulWidget {
  final TrailPlace place;
  final double iconSize;

  const TrailPlaceHoursArea({Key key, this.place, this.iconSize = 26.0})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TrailPlaceHoursArea();
}

class _TrailPlaceHoursArea extends State<TrailPlaceHoursArea> {
  String _status;

  TrailPlaceHoursAreaBloc _bloc = TrailPlaceHoursAreaBloc();

  String get _nowDay {
    return [
      'filler',
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday'
    ][DateTime.now().weekday];
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _status = _bloc.getStatusString(widget.place.hoursDetail);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionSection(
      title: Text(
        _status,
        style: TextStyle(
            fontSize: 16.0,
            color: OpenHoursMethods.isOpenNow(widget.place.hoursDetail) || 
                OpenHoursMethods.isOpenLaterToday(widget.place.hoursDetail)
                ? Colors.green
                : Colors.black),
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
                    fontWeight: key == _nowDay
                      ? FontWeight.bold
                      : FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                Spacer(),
                Text(
                  widget.place.hours[key],
                  style: TextStyle(
                    fontSize: 16.0,
                    height: 1.5,
                    fontWeight: key == _nowDay
                      ? FontWeight.bold
                      : FontWeight.normal,
                    color: Colors.black,
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
