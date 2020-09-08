import 'dart:async';
import 'dart:math';

import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/data/trail_place_category.dart';
import 'package:alabama_beer_trail/util/filter_options.dart';
import 'package:alabama_beer_trail/util/geo_methods.dart';
import 'package:alabama_beer_trail/util/location_service.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';

import 'bloc.dart';

/// BLoC for the Trail List Tab screen
class TabScreenTrailListBloc extends Bloc {
  final TrailDatabase _db = TrailDatabase();
  StreamSubscription _placesSubscription;
  FilterOptions _filterOptions;
  LocationService _locationService = LocationService();

  List<TrailPlace> allTrailPlaces = List<TrailPlace>();

  List<TrailPlace> get filteredTrailPlaces {
    // Filter
    List<String> shownCategories = _filterOptions.show.keys
        .where((f) => _filterOptions.show[f])
        .map((e) => e.name)
        .toList();
    List<TrailPlace> filtered = allTrailPlaces
        .where((p) => p.categories.any((c) => shownCategories.contains(c)))
        .toList();
    // Sort
    if (_filterOptions.sort == SortOrder.DISTANCE &&
        _locationService.lastLocation != null) {
      return filtered
        ..sort((a, b) {
          return GeoMethods.calculateDistance(
                  a.location, _locationService.lastLocation)
              .compareTo(GeoMethods.calculateDistance(
                  b.location, _locationService.lastLocation));
        });
    } else {
      return filtered
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    }
  }

  final _allPlacesStreamController = StreamController<List<TrailPlace>>();
  Stream<List<TrailPlace>> get allTrailPlaceStream =>
      _allPlacesStreamController.stream;

  final _filteredPlacesStreamController = StreamController<List<TrailPlace>>();
  Stream<List<TrailPlace>> get filteredTraiilPlacesStream =>
      _filteredPlacesStreamController.stream;

  TabScreenTrailListBloc() {
    _locationService.locationStream.listen(_onLocationUpdate);
    allTrailPlaces = _db.places;
    var showAll = Map<TrailPlaceCategory, bool>();
    TrailAppSettings.filterStrings.forEach((f) => showAll[f] = true);
    _filterOptions = FilterOptions(
        LocationService().lastLocation == null
            ? SortOrder.ALPHABETICAL
            : SortOrder.DISTANCE,
        showAll);
    _placesSubscription = _db.placesStream.listen(_onPlacesUpdate);
  }

  void changeFilter(FilterOptions filter) {
    _filterOptions = filter;
    _filteredPlacesStreamController.sink.add(filteredTrailPlaces);
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

  @override
  void dispose() {
    _placesSubscription.cancel();
    _allPlacesStreamController.close();
    _filteredPlacesStreamController.close();
  }
}
