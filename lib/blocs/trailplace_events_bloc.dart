import 'dart:async';

import 'package:alabama_beer_trail/blocs/bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/trail_event.dart';

/// BLoC for a TrailPlaceEvent screen
class TrailPlaceEventsBloc extends Bloc {
  TrailDatabase _db;
  int _locationTaxonomy;
  StreamSubscription _eventsSubscription;
  List<TrailEvent> _allTrailPlaceEvents = List<TrailEvent>();

  /// Returns a list of upcoming trail place events
  ///
  /// In order for this to be accurate, the trail place data entry must
  /// include a correct "location taxonomy" for events
  List<TrailEvent> get trailPlaceEvents => _allTrailPlaceEvents
      .where((e) =>
          e.locationTaxonomy == _locationTaxonomy &&
          e.end.compareTo(DateTime.now()) >= 0)
      .toList();

  final _eventsController = StreamController<List<TrailEvent>>();

  /// Stream for upcoming events for the trail place
  Stream<List<TrailEvent>> get trailEventsStream => _eventsController.stream;

  /// Default constructor
  TrailPlaceEventsBloc(int locationTaxonomy, TrailDatabase db) {
    _db = db;
    _allTrailPlaceEvents = _db.events;
    _locationTaxonomy = locationTaxonomy;
    _eventsSubscription = _db.eventsStream.listen(_onEventsUpdate);
  }

  /// Callback for event data updates
  void _onEventsUpdate(List<TrailEvent> events) {
    _allTrailPlaceEvents =
        events.where((e) => e.locationTaxonomy == _locationTaxonomy);
    _eventsController.add(null);
    _eventsController.add(trailPlaceEvents);
  }

  @override
  void dispose() {
    _eventsController.close();
    _eventsSubscription.cancel();
  }
}
