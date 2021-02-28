// Copyright (c) 2021, Fermented Software.
import 'package:beer_trail_app/blocs/trophy_progress_checkins_bloc.dart';
import 'package:trail_database/domain/trail_trophy_total_checkins_any_place.dart';
import 'package:flutter/material.dart';

class TrailTrophyProgressTotalCheckinsAnyPlace extends StatelessWidget {
  final TrailTrophyTotalCheckinsAnyPlace trophy;

  const TrailTrophyProgressTotalCheckinsAnyPlace(
      {Key key, @required this.trophy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TrophyProgressCheckinsBloc _bloc = TrophyProgressCheckinsBloc();

    return StreamBuilder(
      stream: _bloc.stream,
      initialData: _bloc.placeStatuses,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Icon(Icons.error));
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Earn this achievement by checking into a single place at least ${trophy.checkinCountRequired} times.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
