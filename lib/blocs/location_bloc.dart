import 'dart:async';
import 'dart:math';

import 'package:location/location.dart';

import 'bloc.dart';

class LocationBloc extends Bloc {
  static final LocationBloc _singleton = LocationBloc._internal();

  factory LocationBloc() {
    return _singleton;
  }

  LocationBloc._internal() {
    _location.hasPermission().then((result) {
      this.hasPermission = result;
    });
  }

  final _location = Location();
  bool hasPermission = false;
  Point lastLocation;
  final _locationStreamController = StreamController<Point>.broadcast();
  Stream<Point> get locationStream => this._locationStreamController.stream;

  @override
  void dispose() {
    _locationStreamController.close();
  }

  Future<void> refreshLocation() async {
    _location.hasPermission().then((result) {
      this.hasPermission = result;
      if (hasPermission) {
        _location.getLocation().then((data) {
          this.lastLocation = Point(data.latitude, data.longitude);
          _locationStreamController.sink.add(this.lastLocation);
        });
      } else {
        _location.requestPermission().then((result) {
          if(result) {
            refreshLocation();
          } 
        });
      }
    });
  }
}
