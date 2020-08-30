import 'dart:async';

class EventFilterService {
  /// Singleton Pattern
  static final EventFilterService _instance = EventFilterService.internal();
  factory EventFilterService() {
    return _instance;
  }
  EventFilterService.internal();

  EventFilter _filter = EventFilter(distance: 50.0);
  EventFilter get filter => _filter;

  final _controller = StreamController<EventFilter>.broadcast();
  get stream => _controller.stream;

  void updateFilter({double distance}) {
    _filter.distance = distance;
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