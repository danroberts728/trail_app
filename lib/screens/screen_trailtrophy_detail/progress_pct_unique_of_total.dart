import 'package:alabama_beer_trail/blocs/trail_places_bloc.dart';
import 'package:alabama_beer_trail/blocs/user_checkins_bloc.dart';
import 'package:alabama_beer_trail/data/trail_trophy_pct_unique_of_total.dart';
import 'package:flutter/material.dart';

class TrailTrophyProgressPctUniqueOfTotal extends StatelessWidget {
  final TrailTrophyPctUniqueOfTotal trophy;

  const TrailTrophyProgressPctUniqueOfTotal({Key key, @required this.trophy})
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

                var requiredPercentage = trophy.percentRequired;

                var denominator = trailPlacesSnapshot.data.length;
                var numerator = checkinsSnapshot.data
                    .map((f) {
                      return f.placeId;
                    })
                    .toSet()
                    .length;
                double userPercentage = numerator / denominator * 100;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "You have checked into ",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    Text(userPercentage.toStringAsFixed(
                            100 * userPercentage.truncateToDouble() ==
                                    userPercentage
                                ? 0
                                : 2) +
                        "%",
                        style: TextStyle(

                        ),),
                    Text("of all places."),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Reach "),
                        Text(requiredPercentage.toString() + "%")
                      ],
                    ),
                    Text("to win this trophy.")
                  ],
                );
              });
        });
  }
}
