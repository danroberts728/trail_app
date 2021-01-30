// Copyright (c) 2020, Fermented Software.
import 'package:alabama_beer_trail/blocs/trailplace_hours_area_bloc.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/util/open_hours_methods.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:flutter/material.dart';

/// List of hours for the trail place screen
class TrailPlaceHoursArea extends StatefulWidget {
  final TrailPlace place;
  final double iconSize;
  final double fontSize;

  const TrailPlaceHoursArea(
      {Key key, this.place, this.iconSize = 26.0, this.fontSize = 16.0})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TrailPlaceHoursArea();
}

class _TrailPlaceHoursArea extends State<TrailPlaceHoursArea> {
  String _status;

  bool _isPanelExpanded = false;

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
    return ExpansionPanelList(
      elevation: 0,
      expandedHeaderPadding: EdgeInsets.zero,
      animationDuration: Duration(seconds: 1),
      expansionCallback: (panelIndex, isExpanded) {
        setState(() {
          _isPanelExpanded = !_isPanelExpanded;
        });
      },
      children: [
        ExpansionPanel(
          canTapOnHeader: true,
          isExpanded: _isPanelExpanded,
          headerBuilder: (context, isExpanded) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.access_time,
                    size: widget.iconSize,
                    color: TrailAppSettings.subHeadingColor,
                  ),
                  SizedBox(width: 4.0),
                  Expanded(
                    child: Text(
                      _status,
                      style: TextStyle(
                        fontSize: widget.fontSize,
                        color: OpenHoursMethods.isOpenToday(
                                widget.place.hoursDetail, DateTime.now())
                            ? Colors.green
                            : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          body: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                horizontal: widget.iconSize + 4.0, vertical: 0),
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
                        fontSize: 14.0,
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
                        fontSize: 14.0,
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
        ),
      ],
    );
  }
}
