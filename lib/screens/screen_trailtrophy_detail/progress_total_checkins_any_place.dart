import 'package:alabama_beer_trail/blocs/trail_places_bloc.dart';
import 'package:alabama_beer_trail/blocs/user_checkins_bloc.dart';
import 'package:alabama_beer_trail/data/trail_trophy_total_checkins_any_place.dart';
import 'package:flutter/material.dart';

class TrailTrophyProgressTotalCheckinsAnyPlace extends StatelessWidget {
  final TrailTrophyTotalCheckinsAnyPlace trophy;

  const TrailTrophyProgressTotalCheckinsAnyPlace({Key key, @required this.trophy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TrailPlacesBloc _trailPlacesBloc = TrailPlacesBloc();

    UserCheckinsBloc _userCheckinsBloc = UserCheckinsBloc();

    return StreamBuilder(
        stream: _trailPlacesBloc.trailPlaceStream,
        builder: (context, trailPlacesSnapshot) {
          return StreamBuilder(
              stream: _userCheckinsBloc.checkInStream,
              builder: (context, checkinsSnapshot) {
                if (trailPlacesSnapshot.connectionState ==
                        ConnectionState.waiting ||
                    checkinsSnapshot.connectionState ==
                        ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Earn this achievement by checking into a single place at least ${trophy.checkinCountRequired} times.",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                );
              });
        });
  }
}
