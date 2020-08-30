import 'dart:async';
import 'dart:math';

import 'package:alabama_beer_trail/blocs/tabscreen_trail_events_bloc.dart';
import 'package:alabama_beer_trail/data/trail_event.dart';
import 'package:alabama_beer_trail/util/event_filter_service.dart';
import 'package:alabama_beer_trail/util/geo_methods.dart';
import 'package:alabama_beer_trail/widgets/trailevent_card.dart';
import 'package:flutter/material.dart';

class TabScreenTrailEvents extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabScreenTrailEvents();
}

class _TabScreenTrailEvents extends State<TabScreenTrailEvents> {
  TabScreenTrailEventsBloc _tabScreenTrailEventsBloc =
      TabScreenTrailEventsBloc();

  Point _userLocation;

  EventFilter _eventFilter = EventFilter();

  @override
  void initState() {
    super.initState();
    _tabScreenTrailEventsBloc.filterStream.listen(_onFilterUpdate);
    _tabScreenTrailEventsBloc.locationStream.listen(_onLocationUpdate);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshPulled,
      child: Container(
        color: Colors.black12,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: StreamBuilder(
            stream: _tabScreenTrailEventsBloc.trailEventsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                var upcomingEventsInFilter =
                    snapshot.data.where((TrailEvent e) {
                  Point eventLocation = Point(e.locationLat, e.locationLon);
                  double distance = GeoMethods.calculateDistance(
                      _userLocation, eventLocation);
                  // Show if distance is unkown, it's a featured event, or its within filter
                  return distance == null ||
                      e.featured ||
                      distance <= _eventFilter.distance;
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

  Future<void> _refreshPulled() {
    return Future.delayed(Duration(seconds: 1), () {
      _tabScreenTrailEventsBloc.refreshLocation();
      setState(() {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("Events list updated.")));
      });
    });
  }

  void _onFilterUpdate(EventFilter filter) {
    setState(() {
      _eventFilter = filter;
    });
  }

  void _onLocationUpdate(event) {
    setState(() {
      _userLocation = event;
    });
  }
}
