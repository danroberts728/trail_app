// Copyright (c) 2021, Fermented Software.
import 'dart:async';

import 'package:trail_database/trail_database.dart';


/// BLoC for the Trail List Tab screen
class TabScreenTrailMapBloc {
  TrailDatabase _db;
  StreamSubscription _placesSubscription;

  List<TrailPlace> allTrailPlaces = <TrailPlace>[];

  final _allPlacesStreamController = StreamController<List<TrailPlace>>();
  Stream<List<TrailPlace>> get allTrailPlaceStream =>
      _allPlacesStreamController.stream;

  final _filteredPlacesStreamController = StreamController<List<TrailPlace>>();
  Stream<List<TrailPlace>> get filteredTraiilPlacesStream =>
      _filteredPlacesStreamController.stream;

  TabScreenTrailMapBloc(TrailDatabase db) : assert(db != null) {
    _db = db;
    allTrailPlaces = _db.places;
    _placesSubscription = _db.placesStream.listen(_onPlacesUpdate);
  }

  void _onPlacesUpdate(List<TrailPlace> places) {
    allTrailPlaces = places;
    _allPlacesStreamController.add(null);
    _allPlacesStreamController.sink.add(places);
    _filteredPlacesStreamController.add(null);
  }

  void dispose() {
    _placesSubscription.cancel();
    _filteredPlacesStreamController.close();
  }
}
