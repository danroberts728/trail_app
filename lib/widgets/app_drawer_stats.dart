// Copyright (c) 2020, Fermented Software.
import 'package:alabama_beer_trail/blocs/app_drawer_stats_bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/screens/screen_trailplaces.dart';
import 'package:alabama_beer_trail/widgets/profile_stat.dart';
import 'package:flutter/material.dart';

/// The stats for the app's drawer. Includes the # checked in,
/// # not checked in, and the # favorites
class AppDrawerStats extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppDrawerStats();
}

class _AppDrawerStats extends State<AppDrawerStats> {
  AppDrawerStatsBloc _profileStatsAreaBloc;

  @override void initState() {
    _profileStatsAreaBloc = AppDrawerStatsBloc(TrailDatabase());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _profileStatsAreaBloc.stream,
      initialData: _profileStatsAreaBloc.userPlacesInformation,
      builder: (context, snapshot) {
        if (snapshot == null) {
          return Center(child: LinearProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Icon(Icons.error));
        } else {
          List<UserPlaceInformation> userPlacesInformation = snapshot.data;
          List<UserPlaceInformation> visited =
              userPlacesInformation.where((e) => e.userHasCheckedIn).toList();
          List<UserPlaceInformation> notVisited =
              userPlacesInformation.where((e) => !e.userHasCheckedIn).toList();
          List<UserPlaceInformation> favorited =
              userPlacesInformation.where((e) => e.isUserFavorite).toList();
          return Wrap(
            runAlignment: WrapAlignment.start,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            runSpacing: 8.0,
            spacing: 16.0,
            children: <Widget>[
              ProfileStat(
                value: visited.length,
                postText: "Visited",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      settings: RouteSettings(name: 'Visited'),
                      builder: (context) => TrailPlacesScreen(
                        appBarTitle: "Visited",
                        placeIds: visited.map((e) => e.place.id).toList(),
                      ),
                    ),
                  );
                },
              ),
              ProfileStat(
                value: notVisited.length,
                postText: "Not Visited",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      settings: RouteSettings(name: 'Not Visisted'),
                      builder: (context) => TrailPlacesScreen(
                        appBarTitle: "Not Visited",
                        placeIds: notVisited.map((e) => e.place.id).toList(),
                      ),
                    ),
                  );
                },
              ),
              ProfileStat(
                value: favorited.length,
                postText: "Favorites",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      settings: RouteSettings(name: 'Favorites'),
                      builder: (context) => TrailPlacesScreen(
                        appBarTitle: "Favorites",
                        placeIds: favorited.map((e) => e.place.id).toList(),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        }
      },
    );
  }
}
