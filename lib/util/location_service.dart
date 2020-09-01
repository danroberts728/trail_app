import 'dart:async';
import 'dart:math';

import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:location/location.dart';

class LocationService {
  static final LocationService _singleton = LocationService._internal();

  factory LocationService() {
    return _singleton;
  }

  final _location = Location();
  Point lastLocation;
  final _locationStreamController = StreamController<Point>.broadcast();
  Stream<Point> get locationStream => this._locationStreamController.stream;

  LocationService._internal() {
    _location.hasPermission().then((result) {
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

  void dispose() {
    _locationStreamController.close();
  }

  Future<Point> refreshLocation() async {
    return _location
        .hasPermission()
        .timeout(
          Duration(seconds: 5),
          onTimeout: () => PermissionStatus.denied,
        )
        .then((result) {
      if (result == PermissionStatus.granted) {
        _location
            .getLocation()
            .timeout(
              Duration(seconds: 5),
              onTimeout: () => null,
            )
            .then((result) {
          if (result == null) {
            lastLocation = lastLocation;
          } else {
            lastLocation = Point(result.latitude, result.longitude);
            _locationStreamController.sink.add(this.lastLocation);
          }
        });
      } else {
        _location
            .requestPermission()
            .timeout(
              Duration(seconds: 10),
              onTimeout: () => PermissionStatus.denied,
            )
            .then((result) {
          if (result == PermissionStatus.granted) {
            _location
                .getLocation()
                .timeout(
                  Duration(seconds: 5),
                  onTimeout: () => null,
                )
                .then((result) {
              if (result == null) {
                lastLocation = lastLocation;
              } else {
                lastLocation = Point(result.latitude, result.longitude);
                _locationStreamController.sink.add(this.lastLocation);
              }
            });
          } else {
            lastLocation = null;
          }
        });
      }
      return lastLocation;
    });
  }
}
