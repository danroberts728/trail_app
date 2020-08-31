import 'package:alabama_beer_trail/blocs/trophy_progress_checkins_bloc.dart';
import 'package:alabama_beer_trail/data/trail_trophy_total_unique_checkins.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:flutter/material.dart';

class TrailTrophyProgressTotalUniqueCheckins extends StatelessWidget {
  final TrailTrophyTotalUniqueCheckins trophy;

  const TrailTrophyProgressTotalUniqueCheckins({Key key, @required this.trophy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TrophyProgressCheckinsBloc _bloc = TrophyProgressCheckinsBloc();
    return StreamBuilder(
        stream: _bloc.stream,
        initialData: _bloc.placeStatuses,
        builder: (context, AsyncSnapshot<List<TrailPlaceCheckInStatus>> snapshot) {
          
                if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                var requiredCount = trophy.uniqueCountRequired;
                var currentCount = snapshot.data
                  .where((p) => p.hasUniqueCheckin)
                  .length;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "You have checked into ",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      currentCount.toString(),
                      style: TextStyle(
                        fontSize: 26.0,
                        color: TrailAppSettings.attentionColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "different breweries.",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(height: 18.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Check in to ",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        Text(
                          requiredCount.toString(),
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    Text(
                      "breweries to win this trophy",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    )
                  ],
                );
              });
  }
}
