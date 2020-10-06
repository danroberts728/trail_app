import 'dart:async';
import 'dart:math';

import 'package:alabama_beer_trail/blocs/bloc.dart';
import 'package:alabama_beer_trail/util/event_filter_service.dart';
import 'package:alabama_beer_trail/util/geo_methods.dart';
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

  List<TrailEvent> _allTrailEvents = List<TrailEvent>();
  List<TrailEvent> filteredTrailEvents = List<TrailEvent>();
  EventFilter filter = EventFilter();
  Point lastLocation;

  final _eventsController = StreamController<List<TrailEvent>>();
  final _locationController = StreamController<Point>();
  Stream<List<TrailEvent>> get trailEventsStream => _eventsController.stream;
  Stream<Point> get locationStream => _locationController.stream;

  TabScreenTrailEventsBloc() {
    _allTrailEvents = _db.events;
    _eventsSubscription = _db.eventsStream.listen(_onEventsUpdate);
    _locationSubscription = _location.locationStream.listen(_onLocationUpdate);
    _eventFilterServiceSubscription =
        _eventFilterService.stream.listen(_onFilterUpdate);
  }

  void _onEventsUpdate(List<TrailEvent> events) {
    _allTrailEvents =
        events.where((e) => e.end.compareTo(DateTime.now()) >= 0).toList();
    filteredTrailEvents = _getFilteredEvents();
    _eventsController.add(null);
    _eventsController.sink.add(filteredTrailEvents);
  }

  void _onLocationUpdate(event) {
    lastLocation = Point(event.x, event.y);
    filteredTrailEvents = _getFilteredEvents();
    _eventsController.add(null);
    _eventsController.sink.add(filteredTrailEvents);
  }

  void _onFilterUpdate(EventFilter event) {
    filter = event;
    filteredTrailEvents = _getFilteredEvents();
    _eventsController.add(null);
    _eventsController.sink.add(filteredTrailEvents);
  }

  List<TrailEvent> _getFilteredEvents() {
    return List<TrailEvent>.from(_allTrailEvents.where((TrailEvent e) {
      Point eventLocation = Point(e.locationLat, e.locationLon);
      double distance =
          GeoMethods.calculateDistance(lastLocation, eventLocation);
      // Show if distance is unkown, it's a featured event, or its within filter
      return distance == null || e.featured || distance <= filter?.distance ??
          double.infinity;
    }).toList());
  }

  Future<void> refreshLocation() {
    return _location.refreshLocation();
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
    _locationController.close();
  }
}
