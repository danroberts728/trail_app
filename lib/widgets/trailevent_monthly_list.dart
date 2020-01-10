import 'dart:math';

import 'package:alabama_beer_trail/blocs/event_filter_bloc.dart';
import 'package:alabama_beer_trail/blocs/events_bloc.dart';
import 'package:alabama_beer_trail/blocs/location_bloc.dart';
import 'package:alabama_beer_trail/data/trail_event.dart';
import 'package:alabama_beer_trail/util/geo_methods.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/widgets/trailevent_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthlyEventsList extends StatefulWidget {
  final DateTime month;
  final Function onEmpty;

  const MonthlyEventsList({Key key, @required this.month, this.onEmpty})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MonthlyEventsList(this.month);
  }
}

class _MonthlyEventsList extends State<MonthlyEventsList> {
  final DateTime month;
  MonthlyEventsBloc _thisMonthEventsBloc;
  EventFilterBloc _eventFilterBloc = EventFilterBloc();
  LocationBloc _locationBloc = LocationBloc();
  List<Widget> _columnList;
  double _distanceFilter;

  _MonthlyEventsList(this.month) {    
    this._thisMonthEventsBloc = MonthlyEventsBloc(month);
    this._distanceFilter = _eventFilterBloc.distance ?? double.infinity;
    _eventFilterBloc.eventFilterStream.listen((distance) {
      setState(() {
        this._distanceFilter = distance;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var eventMonthHeader = EventMonthHeader(month: this.month);

    return StreamBuilder(
      stream: _thisMonthEventsBloc.trailEventsStream,
      builder: (context, snapshot) {
        _columnList = <Widget>[
          eventMonthHeader,
        ];
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          List<TrailEvent> events = snapshot.data;

          events = events.where((e) {
            if (_distanceFilter == double.infinity) {
              // Location is 'ALL' return all
              return true;
            } else if (_locationBloc.lastLocation == null) {
              // We do not have user location
              return true;
            } else {
              // Filter events in filter distance (include all filtered)
              if( e.featured ) {
                return true;
              }
              Point eventPoint = Point(e.locationLat, e.locationLon);
              Point userPoint = Point(
                  _locationBloc.lastLocation.x, _locationBloc.lastLocation.y);
              return GeoMethods.calculateDistance(eventPoint, userPoint) <=
                  _distanceFilter;
            }
          }).toList();

          if (events.length == 0) {
            // If no events, don't show anything for this month.
            widget.onEmpty();
            return SizedBox(
              height: 0,
            );
          } else {
            // Otherwise, sort by start time and return
            List<TrailEvent> retval = events
              ..sort((TrailEvent a, TrailEvent b) {
                return a.start.compareTo(b.start);
              });
            retval.forEach((e) {
              _columnList.add(
                TrailEventCard(
                  event: e,
                ),
              );
            });
          }
        }

        return Container(
          child: Column(
            children: _columnList,
          ),
        );
      },
    );
  }
}

class EventMonthHeader extends StatelessWidget {
  final DateTime month;

  const EventMonthHeader({Key key, this.month}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.topLeft,
      margin: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 8.0,
      ),
      child: Text(
        DateFormat("MMMM").format(this.month).toUpperCase() +
            ", " +
            DateFormat("yyyy").format(this.month).toUpperCase(),
        textAlign: TextAlign.start,
        style: TextStyle(
          color: TrailAppSettings.third,
          fontFamily: "Roboto",
          fontFamilyFallback: ["arial narrow"],
          fontSize: 22.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
