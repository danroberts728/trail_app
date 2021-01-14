// Copyright (c) 2020, Fermented Software.
import 'package:alabama_beer_trail/blocs/button_check_in_bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/util/location_service.dart';
import 'package:alabama_beer_trail/util/geo_methods.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/widgets/button_check_in.dart';
import 'package:flutter/material.dart';

class TrailPlaceCheckinArea extends StatelessWidget {
  final TrailPlace place;
  final int checkInsCount;

  final _locationBloc = LocationService();

  TrailPlaceCheckinArea(
      {Key key, @required this.place, @required this.checkInsCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      margin: EdgeInsets.only(
        bottom: 0.0,
        top: 0.0,
      ),
      padding: EdgeInsets.only(
        bottom: 8.0,
      ),
      child: Container(
        margin: EdgeInsets.only(
          bottom: 0,
          top: 0,
        ),
        child: CheckinButton(
          bloc: ButtonCheckInBloc(TrailDatabase()),
          showAlways: true,
          place: this.place,
          canCheckin: _getDistance() < TrailAppSettings.minDistanceToCheckin,
        ),
      ),
    );
  }

  double _getDistance() {
    if (_locationBloc.lastLocation != null) {
      return GeoMethods.calculateDistance(
          _locationBloc.lastLocation, this.place.location);
    } else {
      return double.infinity;
    }
  }
}
