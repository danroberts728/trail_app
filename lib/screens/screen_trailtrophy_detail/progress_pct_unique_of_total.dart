import 'package:beer_trail_app/blocs/trophy_progress_checkins_bloc.dart';
import 'package:beer_trail_app/data/trail_trophy_pct_unique_of_total.dart';
import 'package:beer_trail_app/util/trail_app_settings.dart';
import 'package:flutter/material.dart';

class TrailTrophyProgressPctUniqueOfTotal extends StatelessWidget {
  final TrailTrophyPctUniqueOfTotal trophy;

  const TrailTrophyProgressPctUniqueOfTotal({Key key, @required this.trophy})
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
          var requiredPercentage = trophy.percentRequired;

          var denominator = snapshot.data.length;
          var numerator = snapshot.data.where((p) => p.hasUniqueCheckin).length;
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
              Text(
                userPercentage.toStringAsFixed(
                        100 * userPercentage.truncateToDouble() ==
                                userPercentage
                            ? 0
                            : 1) +
                    "%",
                style: TextStyle(
                  fontSize: 26.0,
                  color: TrailAppSettings.attentionColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "of the trail",
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 18.0),
              Visibility(
                visible: userPercentage < requiredPercentage,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Reach ",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      requiredPercentage.toString() + "%",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              Visibility(
                visible: userPercentage < requiredPercentage,
                child: Text(
                  "to win this trophy",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
