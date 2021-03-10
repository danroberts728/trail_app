// Copyright (c) 2021, Fermented Software.
import 'package:beer_trail_app/blocs/trophy_progress_checkins_bloc.dart';
import 'package:trail_database/domain/trail_trophy_exact_unique_checkins.dart';
import 'package:trailtab_places/trailtab_places.dart';
import 'package:beer_trail_app/screens/screen_trailtrophy_detail/trophy_place_item.dart';
import 'package:flutter/material.dart';

class TrailTrophyProgressExactUniqueCheckins extends StatelessWidget {
  final TrailTrophyExactUniqueCheckins trophy;

  TrailTrophyProgressExactUniqueCheckins({Key key, @required this.trophy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TrophyProgressCheckinsBloc _bloc = TrophyProgressCheckinsBloc();

    return StreamBuilder(
      stream: _bloc.stream,
      initialData: _bloc.placeStatuses,
      builder:
          (context, AsyncSnapshot<List<TrailPlaceCheckInStatus>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Icon(Icons.error));
        } else {
          List<TrailPlaceCheckInStatus> trailPlaces = snapshot.data;
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: trophy.requiredCheckins.length,
            itemBuilder: (context, index) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              var trophyPlaces = trophy.requiredCheckins..sort();

              TrailPlaceCheckInStatus place = trailPlaces.firstWhere(
                (p) => p.place.id == trophyPlaces[index],
                orElse: () {
                  return null;
                },
              );

              if (place == null) {
                return Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.warning,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 6.0,
                      ),
                      Text(
                        "Error - Place doesn't exist",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return InkWell(
                onTap: () {
                  Feedback.forTap(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      settings: RouteSettings(
                        name: place.place.name,
                      ),
                      builder: (context) => TrailPlaceDetailScreen(
                        place: place.place,
                      ),
                    ),
                  );
                },
                child: TrophyPlaceItem(
                  place: place.place,
                  isChecked: place.hasUniqueCheckin,
                ),
              );
            },
          );
        }
      },
    );
  }
}
