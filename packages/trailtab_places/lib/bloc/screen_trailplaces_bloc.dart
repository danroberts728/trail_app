// Copyright (c) 2020, Fermented Software.
import 'dart:async';

import 'package:trail_database/trail_database.dart';

/// BLoC for ScreenTrailList objects
class ScreenTrailListBloc {
  /// A reference to the central database
  TrailDatabase _db;

  /// A subscription to trail places data
  StreamSubscription _placesSubscription;

  /// The current list of trail places
  List<TrailPlace> trailPlaces = [];

  /// Controller for this BLoC's stream
  final StreamController<List<TrailPlace>> _placesStreamController =
      StreamController<List<TrailPlace>>();

  /// The stream for updates to the trail places
  Stream<List<TrailPlace>> get trailPlaceStream =>
      _placesStreamController.stream;

  /// Default constructor
  ScreenTrailListBloc(TrailDatabase db) : assert(db != null) {
    _db = db;
    trailPlaces = _db.places;
    _placesSubscription = _db.placesStream.listen(_onPlacesUpdate);
  }

  /// Callback when places are updated
  void _onPlacesUpdate(List<TrailPlace> places) {
    trailPlaces = places;
    _placesStreamController.add(null);
    _placesStreamController.sink.add(places);
  }

  /// Dispose object
  void dispose() {
    _placesSubscription.cancel();
    _placesStreamController.close();
  }
}
