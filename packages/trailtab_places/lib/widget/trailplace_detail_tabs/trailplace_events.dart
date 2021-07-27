// Copyright (c) 2020, Fermented Software.
import 'package:trail_database/domain/trail_event.dart';
import 'package:trailtab_events/trailtab_events.dart';
import 'package:flutter/material.dart';

/// UI element for a list of events at a trail place
class TrailPlaceEvents extends StatelessWidget {
  /// The events to show
  final List<TrailEvent> events;

  const TrailPlaceEvents({Key key, @required this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: events.length,
      itemBuilder: (context, index) {
        TrailEvent event = events[index];
        return TrailEventCard(
          key: ValueKey(event.id),
          startMargin: 4.0,
          endMargin: 4.0,
          bottomMargin: 0.0,
          showImage: true,
          elevation: 8.0,
          event: event,
        );
      },
    );
  }
}
