import 'dart:async';
import 'package:alabama_beer_trail/util/location_service.dart';

class EventFilterService {
  /// Singleton Pattern
  static final EventFilterService _instance = EventFilterService.internal();
  factory EventFilterService() {
    return _instance;
  }
  EventFilterService.internal() {
    _filter = EventFilter(
        distance:
            _locationService.lastLocation == null ? double.infinity : 50.0);
  }

  EventFilter _filter;
  EventFilter get filter => _filter;

  LocationService _locationService = LocationService();

  final _controller = StreamController<EventFilter>.broadcast();
  get stream => _controller.stream;

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
      _filter.distance = distance;
    }    
    _controller.sink.add(filter);
  }

  dispose() {
    _controller.close();
  }
}

class EventFilter {
  double distance;
  EventFilter({this.distance = 50.0});
}
