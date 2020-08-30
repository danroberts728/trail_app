import 'dart:async';
import 'dart:math';

import 'package:alabama_beer_trail/blocs/bloc.dart';
import 'package:alabama_beer_trail/util/event_filter_service.dart';
import 'package:alabama_beer_trail/util/location_service.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/trail_event.dart';

/// BLoC for the Trail Events Tab screen
class TabScreenTrailEventsBloc extends Bloc {
  final TrailDatabase _db = TrailDatabase();
  final LocationService _location = LocationService();
  final EventFilterService _eventFilterService = EventFilterService();

  StreamSubscription _eventsSubscription;
  StreamSubscription _locationSubscription;
  StreamSubscription _eventFilterServiceSubscription;

  List<TrailEvent> trailEvents = List<TrailEvent>();
  EventFilter filter;
  Point lastLocation;

  final _eventsController = StreamController<List<TrailEvent>>();
  final _eventFilterController = StreamController<EventFilter>();
  final _locationController = StreamController<Point>();
  Stream<List<TrailEvent>> get trailEventsStream => _eventsController.stream;
  Stream<EventFilter> get filterStream => _eventFilterController.stream;
  Stream<Point> get locationStream => _locationController.stream;

  TabScreenTrailEventsBloc() {
    trailEvents = _db.events;
    _eventsSubscription = _db.eventsStream.listen(_onEventsUpdate);
    _locationSubscription =
        _location.locationStream.listen(_onLocationUpdate);
    _eventFilterServiceSubscription = _eventFilterService.stream.listen(_onFilterUpdate);
  }

  void _onEventsUpdate(List<TrailEvent> events) {
    trailEvents =
        events.where((e) => e.end.compareTo(DateTime.now()) >= 0).toList();
    _eventsController.sink.add(trailEvents);
  }

  void _onLocationUpdate(event) {
    lastLocation = Point(event.x, event.y);
    _locationController.sink.add(lastLocation);
  }

  void _onFilterUpdate(EventFilter event) {
    filter = event;
    _eventFilterController.sink.add(filter);
  }

  void refreshLocation() {
    _location.refreshLocation();
  }
  
  void updateDistanceFilter(double distance) {
    _eventFilterService.updateFilter(distance: distance);
  }

  @override
  void dispose() {
    _eventsSubscription.cancel();
    _locationSubscription.cancel();
    _eventFilterServiceSubscription.cancel();
    _eventsController.close();
    _eventFilterController.close();
    _locationController.close();
  }
}
