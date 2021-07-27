// Copyright (c) 2021, Fermented Software
library trail_location_service;
export 'geo_methods.dart';
export 'location_off_dialog.dart';

import 'dart:async';
import 'dart:math';

import 'package:location/location.dart';

class TrailLocationService {
  static final TrailLocationService _singleton = TrailLocationService._internal();

  factory TrailLocationService() {
    return _singleton;
  }

  final _location = Location();
  Point lastLocation;
  final _locationStreamController = StreamController<Point>.broadcast();
  Stream<Point> get locationStream => this._locationStreamController.stream;

  TrailLocationService._internal() {
    _location.hasPermission().then((result) {
      if (result == PermissionStatus.granted) {
        this._location.changeSettings(
              interval: locationUpdateIntervalMs,
            );
        this._location.onLocationChanged.listen((data) {
          this.lastLocation = Point(data.latitude, data.longitude);
          _locationStreamController.sink.add(this.lastLocation);
        });
      }
    });
  }

  /// Gets or sets the update interval in ms.
  int locationUpdateIntervalMs = 5000; // 5 sec default

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
