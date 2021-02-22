// Copyright (c) 2020, Fermented Software.
import 'package:beer_trail_app/blocs/button_check_in_bloc.dart';
import 'package:beer_trail_app/data/trail_database.dart';
import 'package:beer_trail_app/data/trail_place.dart';
import 'package:trail_auth/trail_auth.dart';
import 'package:beer_trail_app/widgets/button_check_in.dart';
import 'package:flutter/material.dart';

class TrailPlaceCheckinArea extends StatelessWidget {
  final TrailPlace place;
  final int checkInsCount;

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
          appAuth: TrailAuth(),
          showAlways: true,
          place: this.place,
        ),
      ),
    );
  }
}
