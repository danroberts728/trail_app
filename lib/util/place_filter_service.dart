import 'dart:async';
import 'package:alabama_beer_trail/data/check_in.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/util/geo_methods.dart';
import 'package:alabama_beer_trail/util/location_service.dart';
import 'package:alabama_beer_trail/util/open_hours_methods.dart';
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
      sort: _locationService.lastLocation == null
        ? SortOrder.ALPHABETICAL
        : SortOrder.DISTANCE,
      categories: showAll,
    );
  }

  PlaceFilter filter;
  LocationService _locationService = LocationService();

  final StreamController<PlaceFilter> _controller =
      StreamController<PlaceFilter>.broadcast();
  Stream<PlaceFilter> get stream => _controller.stream;

  void updateSort(SortOrder sortOrder) {
    if (sortOrder == SortOrder.DISTANCE &&
        _locationService.lastLocation == null) {
      _locationService.refreshLocation().then((value) {
        filter.sort =
            value == null ? SortOrder.ALPHABETICAL : SortOrder.DISTANCE;
      });
    } else {
      filter.sort = sortOrder;
    }
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

  void updateHoursOption(HoursOption option) {
    filter.hoursOption = option;
    _controller.sink.add(filter);
  }

  bool anyCategoriesFalse() {
    return filter.categories.keys.any((c) => filter.categories[c] == false);
  }

  /// Is the [place] open today? Returns false
  /// if unable to determine.
  bool isOpenToday(TrailPlace place) {
    if (place.hoursDetail == null) {
      return false;
    }
    return OpenHoursMethods.isOpenLaterToday(place.hoursDetail);
  }

  /// Is the [place] open now? Returns false
  /// if unable to determine.
  bool isOpenNow(TrailPlace place) {
    if (place.hoursDetail == null) {
      return false;
    }
    return OpenHoursMethods.isOpenNow(place.hoursDetail);
  }

  List<TrailPlace> applyFilter(
      {List<TrailPlace> allPlaces,
      List<CheckIn> checkIns,
      bool filterHours = true}) {
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
        filtered = filtered
            .where((p) => checkIns.map<String>((e) => e.placeId).contains(p.id))
            .toList();
      } else if (!filter.visited && filter.notVisited) {
        // Show only not visisted
        filtered = filtered
            .where(
                (p) => !checkIns.map<String>((e) => e.placeId).contains(p.id))
            .toList();
      } else if (!filter.visited && !filter.notVisited) {
        // Show nothing basically
        filtered = List<TrailPlace>();
      }
    }
    if (filterHours) {
      // Filter By Hours
      if (filter.hoursOption == HoursOption.OPEN_TODAY) {
        filtered = filtered.where((p) => isOpenToday(p)).toList();
      } else if (filter.hoursOption == HoursOption.OPEN_NOW) {
        filtered = filtered.where((p) => isOpenNow(p)).toList();
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
  HoursOption hoursOption;

  PlaceFilter(
      {this.sort = SortOrder.DISTANCE,
      this.categories,
      this.visited = true,
      this.notVisited = true,
      this.hoursOption = HoursOption.ALL})
      : assert(categories != null);
}

enum SortOrder {
  ALPHABETICAL,
  DISTANCE,
}

enum HoursOption {
  ALL,
  OPEN_NOW,
  OPEN_TODAY,
}
