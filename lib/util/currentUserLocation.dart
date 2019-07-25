import 'dart:async';

import 'package:location/location.dart';
import '../util/const.dart';

class CurrentUserLocation {
  var _location = new Location();
  double latitude;
  double longitude;
  bool hasPermission;
  StreamController<Point> streamBroadcast = StreamController.broadcast();

  static final CurrentUserLocation _instance =
      CurrentUserLocation._privateConstructor();
  factory CurrentUserLocation() {
    return _instance;
  }

  CurrentUserLocation._privateConstructor() {
    this.streamBroadcast.stream.timeout(
      Duration(seconds: Constants.options.locationUpdatesIntervalMs * 2),
      onTimeout: _processLocationChangeTimeout);

    // Get an initial update, then set up for periodic updates
    this._getLocationNow().then((Point p) {
      this.latitude = p.latitude;
      this.longitude = p.longitude;
      this.hasPermission = p.latitude == null ? false : true;
      this._location.changeSettings(
            interval: Constants.options.locationUpdatesIntervalMs,
            distanceFilter: Constants.options.locationDisplacementFilterM,
          );
      this._location.onLocationChanged().listen(_processLocationChange);
    });
  }

  void dispose() {
    streamBroadcast.close();
  }

  void _processLocationChange(LocationData data) {
    this.latitude = data.latitude;
    this.longitude = data.longitude;
    this.hasPermission = true;
    this.streamBroadcast.add(Point(latitude, longitude));
  }

  /// Send the last-known location, even if null
  void _processLocationChangeTimeout(EventSink sink) {
    this.streamBroadcast.add(Point(latitude, longitude));
  }

  Future<Point> _getLocationNow() {
    if(this.latitude != null && this.longitude != null) {
      return Future<Point>.value(Point(this.latitude, this.longitude));
    }
    else {
      return _location.hasPermission().then((bool hasPermission) {
        if (hasPermission) {
          return _location.getLocation().then((LocationData data) {
            this.latitude = data.latitude;
            this.longitude = data.longitude;
            this.hasPermission = true;
            return Point(this.latitude, this.longitude);
          });
        } else {
          this.latitude = null;
          this.longitude = null;
          this.hasPermission = false;
          return null;
        }
      });
    }
  }
}

class Point {
  final double latitude;
  final double longitude;

  Point(this.latitude, this.longitude);
}
