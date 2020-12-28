import 'dart:async';
import 'dart:math';

import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/util/place_filter.dart';
import 'package:alabama_beer_trail/util/location_service.dart';

import 'bloc.dart';

/// BLoC for the Trail List Tab screen
class TabScreenTrailListBloc extends Bloc {
  final TrailDatabase _db = TrailDatabase();
  StreamSubscription _placesSubscription;
  StreamSubscription _placeFilterSubscription;
  PlaceFilter _placeFilter;
  LocationService _locationService = LocationService();

  List<TrailPlace> allTrailPlaces = <TrailPlace>[];
  List<TrailPlace> get filteredTrailPlaces =>
    _placeFilter.applyFilter(allPlaces: allTrailPlaces);

  final _allPlacesStreamController = StreamController<List<TrailPlace>>();
  Stream<List<TrailPlace>> get allTrailPlaceStream =>
      _allPlacesStreamController.stream;

  final _filteredPlacesStreamController = StreamController<List<TrailPlace>>();
  Stream<List<TrailPlace>> get filteredTraiilPlacesStream =>
      _filteredPlacesStreamController.stream;

  TabScreenTrailListBloc(PlaceFilter filter) {
    _placeFilter = filter;
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
