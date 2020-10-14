import 'dart:async';
import 'package:alabama_beer_trail/data/check_in.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/util/geo_methods.dart';
import 'package:alabama_beer_trail/util/location_service.dart';
import 'package:alabama_beer_trail/util/open_hours_methods.dart';

class PlaceFilter {
  PlaceFilterCriteria filterCriteria = PlaceFilterCriteria(
      sort: SortOrder.DISTANCE, hoursOption: HoursOption.ALL);
  LocationService _locationService = LocationService();

  final StreamController<PlaceFilterCriteria> _controller =
      StreamController<PlaceFilterCriteria>.broadcast();
  Stream<PlaceFilterCriteria> get stream => _controller.stream;

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

  void updateHoursOption(HoursOption option) {
    filterCriteria.hoursOption = option;
    _controller.sink.add(filterCriteria);
  }

  /// Is the [place] open today? Returns false
  /// if unable to determine.
  bool isOpenLaterToday(TrailPlace place) {
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
    List<TrailPlace> filtered = List<TrailPlace>.from(allPlaces);
    if (filterHours) {
      // Filter By Hours
      if (filterCriteria.hoursOption == HoursOption.OPEN_TODAY) {
        filtered = filtered
            .where((p) => (isOpenNow(p) || isOpenLaterToday(p)))
            .toList();
      } else if (filterCriteria.hoursOption == HoursOption.OPEN_NOW) {
        filtered = filtered.where((p) => isOpenNow(p)).toList();
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

class PlaceFilterCriteria {
  SortOrder sort;
  HoursOption hoursOption;

  PlaceFilterCriteria(
      {this.sort = SortOrder.DISTANCE, this.hoursOption = HoursOption.ALL});
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
