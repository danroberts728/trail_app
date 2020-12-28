// Copyright (c) 2020, Fermented Software.
import 'dart:async';
import 'dart:math';

import 'package:alabama_beer_trail/blocs/bloc.dart';
import 'package:alabama_beer_trail/util/event_filter.dart';
import 'package:alabama_beer_trail/util/geo_methods.dart';
import 'package:alabama_beer_trail/util/location_service.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/trail_event.dart';

/// BLoC for the Trail Events Tab screen
class TabScreenTrailEventsBloc extends Bloc {
  final TrailDatabase _db = TrailDatabase();
  final LocationService _location = LocationService();

  StreamSubscription _eventsSubscription;
  StreamSubscription _locationSubscription;
  StreamSubscription _eventFilterServiceSubscription;

  List<TrailEvent> _allTrailEvents = <TrailEvent>[];
  List<TrailEvent> filteredTrailEvents = <TrailEvent>[];
  EventFilter _filter;
  Point lastLocation;

  final _eventsController = StreamController<List<TrailEvent>>();
  final _locationController = StreamController<Point>();
  Stream<List<TrailEvent>> get trailEventsStream => _eventsController.stream;
  Stream<Point> get locationStream => _locationController.stream;

  /// Default constructor
  /// [filter] is required for this to work properly
  TabScreenTrailEventsBloc(EventFilter filter) {
    _filter = filter;
    _allTrailEvents = _db.events;
    _eventsSubscription = _db.eventsStream.listen(_onEventsUpdate);
    _locationSubscription = _location.locationStream.listen(_onLocationUpdate);
    _eventFilterServiceSubscription =
        filter.stream.listen(_onFilterUpdate);
  }

  /// Handles an update to the events database table
  void _onEventsUpdate(List<TrailEvent> events) {
    _allTrailEvents =
        events.where((e) => e.end.compareTo(DateTime.now()) >= 0).toList();
    filteredTrailEvents = _getFilteredEvents();
    _eventsController.add(null);
    _eventsController.sink.add(filteredTrailEvents);
  }

  /// Handles an update to the user's location
  void _onLocationUpdate(event) {
    lastLocation = Point(event.x, event.y);
    filteredTrailEvents = _getFilteredEvents();
    _eventsController.add(null);
    _eventsController.sink.add(filteredTrailEvents);
  }

  /// Handles an update to the event filter
  void _onFilterUpdate(EventFilter event) {
    _filter = event;
    filteredTrailEvents = _getFilteredEvents();
    _eventsController.add(null);
    _eventsController.sink.add(filteredTrailEvents);
  }

  /// Returns a filtered list of the events that match
  /// the current filter criteria
  List<TrailEvent> _getFilteredEvents() {
    return List<TrailEvent>.from(_allTrailEvents.where((TrailEvent e) {
      Point eventLocation = Point(e.locationLat, e.locationLon);
      double distance =
          GeoMethods.calculateDistance(lastLocation, eventLocation);
      // Show if distance is unkown, it's a featured event, or its within filter
      return distance == null || e.featured || distance <= (_filter?.distance ??
          double.infinity);
    }).toList());
  }

  /// Refresh the user's location
  Future<void> refreshLocation() {
    return _location.refreshLocation();
  }

  /// Updates the event filter criteria
  void updateDistanceFilter(double distance) {
    _filter.updateFilter(distance: distance);
  }

  /// Dispose the object
  @override
  void dispose() {
    _eventsSubscription.cancel();
    _locationSubscription.cancel();
    _eventFilterServiceSubscription.cancel();
    _eventsController.close();
    _locationController.close();
  }
}
