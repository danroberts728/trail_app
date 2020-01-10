import 'package:alabama_beer_trail/blocs/event_filter_bloc.dart';
import 'package:flutter/material.dart';

class EventFilterFab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EventFilterFab();
}

class _EventFilterFab extends State<EventFilterFab>
    with SingleTickerProviderStateMixin {
  EventFilterBloc _eventFilterBloc = EventFilterBloc();
  double _filterDistance;

  _EventFilterFab() {
    _filterDistance = _eventFilterBloc.distance;
    _eventFilterBloc.eventFilterStream.listen((distance) {
      setState(() {
        _filterDistance = distance;
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
}
