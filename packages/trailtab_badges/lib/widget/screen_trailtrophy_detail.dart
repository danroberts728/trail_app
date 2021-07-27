// Copyright (c) 2020, Fermented Software.
import 'package:trail_database/trail_database.dart';
import 'package:trail_database/domain/trail_trophy.dart';
import 'package:trailtab_badges/widget/completed_trophy.dart';
import 'package:trailtab_badges/widget/progress_any_of_places.dart';
import 'package:trailtab_badges/widget/progress_exact_unique_checkins.dart';
import 'package:trailtab_badges/widget/progress_pct_unique_of_total.dart';
import 'package:trailtab_badges/widget/progress_total_checkins_any_place.dart';
import 'package:trailtab_badges/widget/progress_total_unique_checkins.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:trailtab_badges/bloc/screen_trailtrophy_detail_bloc.dart';

class TrophyDetailScreen extends StatelessWidget {
  final TrailTrophy trophy;

  TrophyDetailScreen({Key key, this.trophy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenTrailTrophyDetailBloc _bloc = ScreenTrailTrophyDetailBloc(TrailDatabase());

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
                  style: Theme.of(context).textTheme.headline1,
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
                color: Theme.of(context).buttonColor,
              ),
              Visibility(
                visible: hasTrophy,
                child: Center(
                  child: Text(
                    "You have this badge",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.subtitle1.color,
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
                  color: Theme.of(context).buttonColor,
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Center(
                child: Text(
                  "Your Progress",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.subtitle1.color,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Progress
              Builder(
                builder: (context) {
                  if (trophy.type== TrophyType.ExactUniqueCheckins) {
                    return TrailTrophyProgressExactUniqueCheckins(
                      trophy: trophy,
                    );
                  } else if (trophy.type ==
                      TrophyType.PercentUniqueOfTotal) {
                    return TrailTrophyProgressPctUniqueOfTotal(
                      trophy: trophy,
                    );
                  } else if (trophy.type ==
                      TrophyType.TotalCheckinsAtAnyPlace) {
                    return TrailTrophyProgressTotalCheckinsAnyPlace(
                      trophy: trophy,
                    );
                  } else if (trophy.type ==
                      TrophyType.TotalUniqueCheckins) {
                    return TrailTrophyProgressTotalUniqueCheckins(
                      trophy: trophy,
                    );
                  } else if (trophy.type == TrophyType.AnyOfPlaces) {
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
