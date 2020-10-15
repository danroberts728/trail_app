// Copyright (c) 2020, Fermented Software.
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

  Future<Point> refreshLocation() async {
    return _location
        .requestPermission()
        .timeout(
          Duration(seconds: 10),
          onTimeout: () => PermissionStatus.denied,
        )
        .then((permission) {
      if (permission == PermissionStatus.granted) {
        return _location
            .getLocation()
            .timeout(
              Duration(seconds: 5),
              onTimeout: () => null,
            )
            .then((result) {
          if (result != null) {
            lastLocation = Point(result.latitude, result.longitude);
          }
          _locationStreamController.sink.add(lastLocation);
          return lastLocation;
        });
      } else {
        lastLocation = null;
        return lastLocation;
      }
    });
  }

  void dispose() {
    _locationStreamController.close();
  }
}
