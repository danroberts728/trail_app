// Copyright (c) 2020, Fermented Software.
library trailtab_events;
export 'widget/screen_trail_event_detail.dart';
export 'widget/trail_event_card.dart';

import 'dart:async';

import 'package:trailtab_events/bloc/trailtab_events_bloc.dart';
import 'package:trail_database/trail_database.dart';
import 'package:trailtab_events/util/event_filter.dart';
import 'package:trail_location_service/trail_location_service.dart';
import 'package:trailtab_events/widget/dropdown_event_filter.dart';
import 'package:trailtab_events/widget/trail_event_card.dart';
import 'package:flutter/material.dart';

/// The Trail Events tab screen
class TrailTabEvents extends StatefulWidget {
  const TrailTabEvents({Key key, this.filterDistanceOptions}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TrailTabEvents();
  final List<double> filterDistanceOptions;
}

/// The state for the Trail Events tab
class _TrailTabEvents extends State<TrailTabEvents> {
  /// The BLoC for the app tab selection
  TrailTabEventsBloc _tabScreenTrailEventsBloc;

  /// The filter used for events
  EventFilter _filter;

  /// Controller for the vertical scroll widget
  ScrollController _controller = ScrollController();

  /// Default constructor
  _TrailTabEvents() {
    _filter = EventFilter(locationService: TrailLocationService());
    _tabScreenTrailEventsBloc =
        TrailTabEventsBloc(TrailDatabase(), _filter, TrailLocationService());
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
          controller: _controller,
          child: StreamBuilder(
            stream: _tabScreenTrailEventsBloc.trailEventsStream,
            initialData: _tabScreenTrailEventsBloc.filteredTrailEvents,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Icon(Icons.error));
              } else {
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return DropDownEventFilter(
                        filter: _filter,
                        eventFilterDistances: widget.filterDistanceOptions,
                      );
                    } else {
                      TrailEvent event = snapshot.data[index - 1];
                      return TrailEventCard(
                        key: ValueKey(event.id),
                        startMargin: 4.0,
                        endMargin: 4.0,
                        bottomMargin: 0.0,
                        showImage: true,
                        elevation: 8.0,
                        event: event,
                      );
                    }
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  /// Handle refresh pulldown
  Future<void> _refreshPulled() {
    return _tabScreenTrailEventsBloc.refreshLocation().then((_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Events updated.")));
    });
  }
}
