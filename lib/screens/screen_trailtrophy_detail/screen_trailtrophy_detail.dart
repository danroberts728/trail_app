// Copyright (c) 2020, Fermented Software.
import 'package:alabama_beer_trail/blocs/screen_trailtrophy_bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/trail_trophy.dart';
import 'package:alabama_beer_trail/screens/screen_trailtrophy_detail/completed_trophy.dart';
import 'package:alabama_beer_trail/screens/screen_trailtrophy_detail/progress_any_of_places.dart';
import 'package:alabama_beer_trail/screens/screen_trailtrophy_detail/progress_exact_unique_checkins.dart';
import 'package:alabama_beer_trail/screens/screen_trailtrophy_detail/progress_pct_unique_of_total.dart';
import 'package:alabama_beer_trail/screens/screen_trailtrophy_detail/progress_total_checkins_any_place.dart';
import 'package:alabama_beer_trail/screens/screen_trailtrophy_detail/progress_total_unique_checkins.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TrophyDetailScreen extends StatelessWidget {
  final TrailTrophy trophy;

  TrophyDetailScreen({Key key, this.trophy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenTrailTrophyBloc _bloc = ScreenTrailTrophyBloc(TrailDatabase());

    var hasTrophy = _bloc.earnedTrophies.keys.contains(trophy.id);

    return Scaffold(
      appBar: AppBar(title: Text(trophy.name)),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 16.0,
              ),
              Center(
                child: CachedNetworkImage(
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  fit: BoxFit.contain,
                  imageUrl:
                      hasTrophy ? trophy.activeImage : trophy.inactiveImage,
                ),
              ),
              Center(
                child: Text(
                  trophy.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.0,
                    color: TrailAppSettings.mainHeadingColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Center(
                child: Text(
                  trophy.description,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontStyle: FontStyle.italic,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Divider(
                color: TrailAppSettings.second,
              ),
              Visibility(
                visible: hasTrophy,
                child: Center(
                  child: Text(
                    "You have this badge",
                    style: TextStyle(
                      color: TrailAppSettings.subHeadingColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: hasTrophy,
                child: CompletedTrophy(
                    completedDate: _bloc.earnedTrophies[trophy.id]),
              ),
              Visibility(
                visible: hasTrophy,
                child: Divider(
                  color: TrailAppSettings.second,
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Center(
                child: Text(
                  "Your Progress",
                  style: TextStyle(
                    color: TrailAppSettings.subHeadingColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Progress
              Builder(
                builder: (context) {
                  if (trophy.trophyType == TrophyType.ExactUniqueCheckins) {
                    return TrailTrophyProgressExactUniqueCheckins(
                      trophy: trophy,
                    );
                  } else if (trophy.trophyType ==
                      TrophyType.PercentUniqueOfTotal) {
                    return TrailTrophyProgressPctUniqueOfTotal(
                      trophy: trophy,
                    );
                  } else if (trophy.trophyType ==
                      TrophyType.TotalCheckinsAtAnyPlace) {
                    return TrailTrophyProgressTotalCheckinsAnyPlace(
                      trophy: trophy,
                    );
                  } else if (trophy.trophyType ==
                      TrophyType.TotalUniqueCheckins) {
                    return TrailTrophyProgressTotalUniqueCheckins(
                      trophy: trophy,
                    );
                  } else if (trophy.trophyType == TrophyType.AnyOfPlaces) {
                    return TrailTrophyProgressAnyOfPlaces(
                      trophy: trophy,
                    );
                  } else {
                    return Container();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
