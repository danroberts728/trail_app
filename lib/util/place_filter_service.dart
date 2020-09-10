import 'dart:async';
import 'package:alabama_beer_trail/data/check_in.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/util/geo_methods.dart';
import 'package:alabama_beer_trail/util/location_service.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';

import '../data/trail_place_category.dart';

class PlaceFilterService {
  /// Singleton Pattern
  static final PlaceFilterService _instance = PlaceFilterService.internal();
  factory PlaceFilterService() {
    return _instance;
  }
  PlaceFilterService.internal() {
    var showAll = Map<TrailPlaceCategory, bool>();
    TrailAppSettings.filterStrings.forEach((f) => showAll[f] = true);
    filter = PlaceFilter(
      categories: showAll,
    );
  }

  PlaceFilter filter;
  LocationService _locationService = LocationService();

  final StreamController<PlaceFilter> _controller =
      StreamController<PlaceFilter>.broadcast();
  Stream<PlaceFilter> get stream => _controller.stream;

  void updateSort(SortOrder sortOrder) {
    filter.sort = sortOrder;
    _controller.sink.add(filter);
  }

  void updateCategories(Map<TrailPlaceCategory, bool> categories) {
    filter.categories = categories;
    _controller.sink.add(filter);
  }

  // Set every category to true
  void allCategoriesTrue() {
    filter.categories.keys.forEach((key) => filter.categories[key] = true);
    _controller.sink.add(filter);
  }

  // Set every category to false
  void allCategoriesFalse() {
    filter.categories.keys.forEach((key) => filter.categories[key] = false);
    _controller.sink.add(filter);
  }

  void updateVisited(bool isSelected) {
    filter.visited = isSelected;
    _controller.sink.add(filter);
  }

  void updateNotVisited(bool isSelected) {
    filter.notVisited = isSelected;
    _controller.sink.add(filter);
  }

  void updateIncludeClosed(bool isSelected) {
    filter.includeClosed = isSelected;
    _controller.sink.add(filter);
  }

  void updateFilter({PlaceFilter filter}) {
    filter = filter;
    _controller.sink.add(filter);
  }

  List<TrailPlace> applyFilter(
      {List<TrailPlace> allPlaces, List<CheckIn> checkIns}) {
    // Filter Categories
    List<String> shownCategories = filter.categories.keys
        .where((f) => filter.categories[f])
        .map((e) => e.name)
        .toList();
    List<TrailPlace> filtered = allPlaces
        .where((p) => p.categories.any((c) => shownCategories.contains(c)))
        .toList();
    // Filter Visisted / Not Visited
    if (checkIns != null || (filter.visited && filter.notVisited)) {
      if (filter.visited && !filter.notVisited) {
        // Show only visisted
        filtered = filtered.where(
            (p) => checkIns.map<String>((e) => e.placeId).contains(p.id));
      } else if (!filter.visited && filter.notVisited) {
        // Show only not visisted
        filtered = filtered.where(
            (p) => !checkIns.map<String>((e) => e.placeId).contains(p.id));
      } else if (!filter.visited && !filter.notVisited) {
        // Show nothing basically
        filtered = List<TrailPlace>();
      }
    }

    // Sort
    if (filter.sort == SortOrder.DISTANCE &&
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

  dispose() {
    _controller.close();
  }
}

class PlaceFilter {
  SortOrder sort;
  Map<TrailPlaceCategory, bool> categories;
  bool visited;
  bool notVisited;
  bool includeClosed;

  PlaceFilter(
      {this.sort = SortOrder.DISTANCE,
      this.categories,
      this.visited = true,
      this.notVisited = true,
      this.includeClosed = false})
      : assert(categories != null);
}

enum SortOrder {
  ALPHABETICAL,
  DISTANCE,
}
