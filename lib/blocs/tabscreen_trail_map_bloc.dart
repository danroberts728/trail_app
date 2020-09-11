import 'dart:async';

import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/util/place_filter_service.dart';

import 'bloc.dart';

/// BLoC for the Trail List Tab screen
class TabScreenTrailMapBloc extends Bloc {
  TrailDatabase _db = TrailDatabase();
  StreamSubscription _placeFilterSubscription;
  StreamSubscription _placesSubscription;
  PlaceFilterService _placeFilterService = PlaceFilterService();

  List<TrailPlace> allTrailPlaces = List<TrailPlace>();
  /// Returns a list with the current filter applied, sorted alphabetically by name
  List<TrailPlace> get filteredTrailPlaces =>
      (_placeFilterService.applyFilter(allPlaces: allTrailPlaces)
            ..sort((a, b) {
              return a.name.compareTo(b.name);
            }))
          .toList();

  final _allPlacesStreamController = StreamController<List<TrailPlace>>();
  Stream<List<TrailPlace>> get allTrailPlaceStream =>
      _allPlacesStreamController.stream;

  final _filteredPlacesStreamController = StreamController<List<TrailPlace>>();
  Stream<List<TrailPlace>> get filteredTraiilPlacesStream =>
      _filteredPlacesStreamController.stream;

  TabScreenTrailMapBloc() {
    allTrailPlaces = _db.places;
    _placesSubscription = _db.placesStream.listen(_onPlacesUpdate);
    _placeFilterSubscription =
        _placeFilterService.stream.listen(_onFilterUpdate);
  }

  void _onPlacesUpdate(List<TrailPlace> places) {
    allTrailPlaces = places;
    _allPlacesStreamController.add(null);
    _allPlacesStreamController.sink.add(places);
    _filteredPlacesStreamController.add(null);
    _filteredPlacesStreamController.sink.add(filteredTrailPlaces);
  }

  void _onFilterUpdate(PlaceFilter filter) {
    _filteredPlacesStreamController.sink.add(filteredTrailPlaces);
  }

  @override
  void dispose() {
    _placeFilterSubscription.cancel();
    _placesSubscription.cancel();
    _filteredPlacesStreamController.close();
  }
}
