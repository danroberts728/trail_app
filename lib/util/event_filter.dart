// Copyright (c) 2020, Fermented Software.
import 'dart:async';
import 'package:alabama_beer_trail/util/location_service.dart';

/// A filter for trail events
class EventFilter {

  /// Default constructor. If [locationService] is null, it will use
  /// the LocationService singleton.
  EventFilter({locationService, this.distance = 50.0}) {
    if(locationService == null) {
      _locationService = LocationService();
    }
    if(locationService.lastLocation == null) {
      distance = double.infinity;
    }
  }

  /// The distance criteria for the filter
  double distance;

  /// The location Service used by the filter
  LocationService _locationService;

  final _controller = StreamController<EventFilter>.broadcast();
  get stream => _controller.stream;

  /// Update the filter criteria
  void updateFilter({double distance}) {
    if (distance < 0) {
      distance = 0;
    }

    if(distance < double.infinity && _locationService.lastLocation == null) {
      _locationService.refreshLocation().then((value) {
        distance = value == null
          ? double.infinity
          : distance;
      });
    } else {
      this.distance = distance;
    }    
    _controller.sink.add(this);
  }

  dispose() {
    _controller.close();
  }
}