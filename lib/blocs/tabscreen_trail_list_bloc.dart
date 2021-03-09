// Copyright (c) 2021, Fermented Software.
import 'dart:async';
import 'dart:math';

import 'package:beer_trail_database/trail_database.dart';
import 'package:beer_trail_database/domain/trail_place.dart';
import 'package:beer_trail_app/util/place_filter.dart';
import 'package:trail_location_service/trail_location_service.dart';

import 'bloc.dart';

/// BLoC for the Trail List Tab screen
class TabScreenTrailListBloc extends Bloc {
  TrailDatabase _db;
  StreamSubscription _placesSubscription;
  StreamSubscription _placeFilterSubscription;
  PlaceFilter _placeFilter;
  TrailLocationService _locationService;

  List<TrailPlace> allTrailPlaces = <TrailPlace>[];
  List<TrailPlace> get filteredTrailPlaces =>
      _placeFilter.applyFilter(allPlaces: allTrailPlaces);

  final _allPlacesStreamController = StreamController<List<TrailPlace>>();
  Stream<List<TrailPlace>> get allTrailPlaceStream =>
      _allPlacesStreamController.stream;

  final _filteredPlacesStreamController = StreamController<List<TrailPlace>>();
  Stream<List<TrailPlace>> get filteredTrailPlacesStream =>
      _filteredPlacesStreamController.stream;

  TabScreenTrailListBloc(PlaceFilter filter, TrailDatabase db, TrailLocationService locationService)
      : assert(filter != null), assert(db != null) {
    _db = db;
    _placeFilter = filter;
    _locationService = locationService;
    _locationService.locationStream.listen(_onLocationUpdate);
    allTrailPlaces = _db.places;
    _placesSubscription = _db.placesStream.listen(_onPlacesUpdate);
    _placeFilterSubscription = _placeFilter.stream.listen(_onFilterUpdate);
  }

  Future<void> refreshPulled() {
    return Future.delayed(Duration(seconds: 1))
        .then((result) => _locationService.refreshLocation());
  }

  void _onPlacesUpdate(List<TrailPlace> places) {
    allTrailPlaces = places;
    _allPlacesStreamController.add(null);
    _allPlacesStreamController.sink.add(places);
    _filteredPlacesStreamController.add(null);
    _filteredPlacesStreamController.sink.add(filteredTrailPlaces);
  }

  void _onLocationUpdate(Point newLocation) {
    _filteredPlacesStreamController.add(null);
    _filteredPlacesStreamController.sink.add(filteredTrailPlaces);
  }

  void _onFilterUpdate(PlaceFilterCriteria filter) {
    _filteredPlacesStreamController.sink.add(filteredTrailPlaces);
  }

  @override
  void dispose() {
    _placesSubscription.cancel();
    _placeFilterSubscription.cancel();
    _allPlacesStreamController.close();
    _filteredPlacesStreamController.close();
  }
}
