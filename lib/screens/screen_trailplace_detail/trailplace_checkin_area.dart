import 'package:alabama_beer_trail/blocs/location_bloc.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/util/geo_methods.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/widgets/button_check_in.dart';
import 'package:alabama_beer_trail/widgets/check_in_count_widget.dart';
import 'package:flutter/material.dart';

class TrailPlaceCheckinArea extends StatelessWidget {
  final checkinsCount;
  final overrideWording;
  final TrailPlace place;

  final LocationBloc _locationBloc = LocationBloc();

  TrailPlaceCheckinArea(
      {Key key, this.checkinsCount, this.overrideWording, this.place})
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              bottom: 6.0,
            ),
            child: CheckinButton(
              showAlways: true,
              place: this.place,
              canCheckin:
                  _getDistance() < TrailAppSettings.minDistanceToCheckin,
            ),
          ),
          CheckInCountWidget(
            count: this.checkinsCount,
            icon: Icons.check,
            visible: true,
            fontSize: 14.0,
            iconSize: 16.0,
            iconColor: TrailAppSettings.attentionColor,
            fontColor: Colors.black45,
            overrideTextNoCheckins: overrideWording,
            overrideTextOneCheckins: overrideWording,
            overrideTextManyCheckins: overrideWording,
          ),
        ],
      ),
    );
  }

  double _getDistance() {
    if (_locationBloc.hasPermission) {
      return GeoMethods.calculateDistance(
          _locationBloc.lastLocation, this.place.location);
    } else {
      return double.infinity;
    }
  }
}
