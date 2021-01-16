// Copyright (c) 2020, Fermented Software.
import 'dart:async';
import 'package:alabama_beer_trail/model/check_in.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/util/geo_methods.dart';
import 'package:alabama_beer_trail/util/location_service.dart';
import 'package:alabama_beer_trail/util/open_hours_methods.dart';

/// A place filter with filter criteria and methods for sorting
/// and filtering a list of places to match the criteria
class PlaceFilter {
  /// The filter criteria
  PlaceFilterCriteria filterCriteria = PlaceFilterCriteria(
      sort: LocationService().lastLocation != null
          ? SortOrder.DISTANCE
          : SortOrder.ALPHABETICAL,
      hoursOption: HoursOption.ALL);
  LocationService _locationService = LocationService();

  final StreamController<PlaceFilterCriteria> _controller =
      StreamController<PlaceFilterCriteria>.broadcast();
  Stream<PlaceFilterCriteria> get stream => _controller.stream;

  /// Updates the sort order of the filter criteria
  void updateSort(SortOrder sortOrder) {
    if (sortOrder == SortOrder.DISTANCE &&
        _locationService.lastLocation == null) {
        _locationService.refreshLocation().then((value) {
        filterCriteria.sort =
            value == null ? SortOrder.ALPHABETICAL : SortOrder.DISTANCE;
      });
    } else {
      filterCriteria.sort = sortOrder;
    }
    _controller.sink.add(filterCriteria);
  }

  /// Updates the hours option of the filter criteria
  void updateHoursOption(HoursOption option) {
    filterCriteria.hoursOption = option;
    _controller.sink.add(filterCriteria);
  }

  /// Applies the filter to the list of [allPlaces]
  /// Returns a list sorted and filtered accroding to the
  /// filter criteria
  List<TrailPlace> applyFilter(
      {List<TrailPlace> allPlaces,
      List<CheckIn> checkIns,
      bool filterHours = true}) {
    List<TrailPlace> filtered = List<TrailPlace>.from(allPlaces);
    if (filterHours) {
      // Filter By Hours
      if (filterCriteria.hoursOption == HoursOption.OPEN_TODAY) {
        filtered = filtered
            .where((p) =>
                OpenHoursMethods.isOpenToday(p.hoursDetail, DateTime.now()))
            .toList();
      } else if (filterCriteria.hoursOption == HoursOption.OPEN_NOW) {
        filtered = filtered
            .where((p) =>
                OpenHoursMethods.isOpenNow(p.hoursDetail, DateTime.now()))
            .toList();
      }
    }
    // Sort
    if (filterCriteria.sort == SortOrder.DISTANCE &&
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

/// Criteria for the filter
class PlaceFilterCriteria {
  SortOrder sort;
  HoursOption hoursOption;

  /// Default constructor
  /// [sort] is how to sort the resulting list
  /// [hoursOption] is how/whether to filter the list by hours
  PlaceFilterCriteria(
      {this.sort = SortOrder.DISTANCE, this.hoursOption = HoursOption.ALL});
}

/// The sort order of a list of places
enum SortOrder {
  ALPHABETICAL,
  DISTANCE,
}

/// Filter options for places based on its open status
enum HoursOption {
  ALL,
  OPEN_NOW,
  OPEN_TODAY,
}
