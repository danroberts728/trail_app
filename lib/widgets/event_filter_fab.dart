import 'dart:async';

import 'package:alabama_beer_trail/util/event_filter_service.dart';
import 'package:flutter/material.dart';

class EventFilterFab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EventFilterFab();
}

class _EventFilterFab extends State<EventFilterFab>
    with SingleTickerProviderStateMixin {
  EventFilterService _eventFilterService = EventFilterService();
  double _filterDistance;
  StreamSubscription _eventFilterSubscription;

  _EventFilterFab() {
    _filterDistance = _eventFilterService.filter.distance;
    _eventFilterSubscription = _eventFilterService.stream.listen((EventFilter filter) {
      setState(() {
        _filterDistance = filter.distance;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: this._filterDistance == double.infinity
          ? Icon(Icons.gps_fixed)
          : Text(
              this._filterDistance.toInt().toString() + " mi",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white,
              ),
            ),
    );
  }

  @override
  void dispose() {
    _eventFilterSubscription.cancel();
    super.dispose();
  }
}
