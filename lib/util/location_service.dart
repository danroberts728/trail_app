import 'dart:async';
import 'dart:math';

import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:location/location.dart';

class LocationService {
  static final LocationService _singleton = LocationService._internal();

  factory LocationService() {
    return _singleton;
  }

  LocationService._internal() {
    _location.hasPermission().then((result) {
      this.hasPermission = result == PermissionStatus.granted;
      if (result == PermissionStatus.granted) {
        this._location.changeSettings(
            interval: TrailAppSettings.locationUpdatesIntervalMs,
        );
        this._location.onLocationChanged.listen((data) {
          this.lastLocation = Point(data.latitude, data.longitude);
          _locationStreamController.sink.add(this.lastLocation);
        });
      }
    });
  }

  final _location = Location();
  bool hasPermission = false;
  Point lastLocation;
  final _locationStreamController = StreamController<Point>.broadcast();
  Stream<Point> get locationStream => this._locationStreamController.stream;

  void dispose() {
    _locationStreamController.close();
  }

  Future<void> refreshLocation() async {
    _location.hasPermission().then((result) {
      this.hasPermission = result == PermissionStatus.granted;
      if (hasPermission) {
        _location.getLocation().then((result) {
          this.lastLocation = Point(result.latitude, result.longitude);
          _locationStreamController.sink.add(this.lastLocation);
        });
      } else {
        _location.requestPermission().then((result) {
          if (result == PermissionStatus.granted) {
           _location.getLocation();
          }
        });
      }
    });
  }
}
