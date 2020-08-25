import 'dart:async';
import 'dart:math';

import 'package:alabama_beer_trail/blocs/event_filter_bloc.dart';
import 'package:alabama_beer_trail/blocs/events_bloc.dart';
import 'package:alabama_beer_trail/blocs/location_bloc.dart';
import 'package:alabama_beer_trail/data/trail_event.dart';
import 'package:alabama_beer_trail/util/geo_methods.dart';
import 'package:alabama_beer_trail/widgets/trailevent_card.dart';
import 'package:flutter/material.dart';

class TabScreenEvents extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabScreenEvents();
}

class _TabScreenEvents extends State<TabScreenEvents> {
  EventsBloc _eventsBloc = EventsBloc();
  EventFilterBloc _eventFilterBloc = EventFilterBloc();
  LocationBloc _locationBloc = LocationBloc();

  Point _userLocation;
  double _filterDistance;

  StreamSubscription _locationSubscription;
  StreamSubscription _eventFilterSubscription;

  _TabScreenEvents();

  @override
  initState() {
    super.initState();
    _locationSubscription = _locationBloc.locationStream.listen(_onLocationUpdate);
    _eventFilterSubscription = _eventFilterBloc.eventFilterStream.listen(_onFilterUpdate);
    _filterDistance = _eventFilterBloc.distance;
  }

  @override
  Widget build(BuildContext context) {
    _userLocation = _locationBloc.lastLocation;
    return RefreshIndicator(
      onRefresh: _refreshPulled,
      child: Container(
        color: Colors.black12,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: StreamBuilder(
            stream: _eventsBloc.trailEventsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                var upcomingEventsInFilter =
                    snapshot.data.where((TrailEvent e) {
                  Point eventLocation = Point(e.locationLat, e.locationLon);
                  double distance =
                      GeoMethods.calculateDistance(_userLocation, eventLocation);
                  if (distance == null) {
                    return true;
                  } else if (e.featured) {
                    return true;
                  } else {
                    return distance <= _filterDistance;
                  }
                }).toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: upcomingEventsInFilter.length,
                      itemBuilder: (context, index) {
                        TrailEvent event = upcomingEventsInFilter[index];
                        return TrailEventCard(
                          startMargin: 4.0,
                          endMargin: 4.0,
                          showImage: true,
                          elevation: 8.0,
                          event: event,
                        );
                      },
                    ),
                    Visibility(
                      visible: upcomingEventsInFilter == null ||
                          upcomingEventsInFilter.length == 0,
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.all(50.0),
                          child: Text(
                            "There are currently no upcoming events scheduled",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void _onLocationUpdate(event) {
    setState(() {
      _userLocation = event;
    });
  }

  Future<void> _refreshPulled() {
    return Future.delayed(Duration(seconds: 1), () {
      _locationBloc.refreshLocation();
      setState(() {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("Events list updated.")));
      });
    });
  }

  void _onFilterUpdate(double filterDistance) {
    setState(() {
      _filterDistance = filterDistance;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _locationSubscription.cancel();
    _eventFilterSubscription.cancel();
  }
}
