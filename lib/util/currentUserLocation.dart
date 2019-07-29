import 'dart:async';
import 'dart:math';

import 'package:location/location.dart';

class CurrentUserLocation {
  var _location = Location();
  bool hasPermission = false;
  Point lastLocation;

  static final CurrentUserLocation _instance =
      CurrentUserLocation._privateConstructor();
  factory CurrentUserLocation() {
    return _instance;
  }

  CurrentUserLocation._privateConstructor() {
    getLocation().then((Point p) {
      if(p == null) {
        this.hasPermission = false;
      }
      else {
        this.hasPermission = true;
      }
    });
  }

  /// Get the user's location as a Point object
  ///
  /// If unable to get the location, it will return null
  Future<Point> getLocation() {
    return this._location.hasPermission().then((bool result) {
      if (result) {
        this.hasPermission = true;
        return this._location.getLocation().then((LocationData data) {
          Point p = Point(data.latitude, data.longitude);
          this.lastLocation = p;
          return p;
        });
      } else {
        return null;
      }
    });
  }
}
