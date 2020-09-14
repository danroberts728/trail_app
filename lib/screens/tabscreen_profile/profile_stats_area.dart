import 'package:alabama_beer_trail/blocs/profile_stats_area_bloc.dart';
import 'package:alabama_beer_trail/screens/screen_trailplaces.dart';
import 'package:alabama_beer_trail/widgets/profile_stat.dart';
import 'package:flutter/material.dart';

class ProfileStatsArea extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileStatsArea();
}

class _ProfileStatsArea extends State<ProfileStatsArea> {
  ProfileStatsAreaBloc _profileStatsAreaBloc = ProfileStatsAreaBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _profileStatsAreaBloc.stream,
      initialData: _profileStatsAreaBloc.userPlacesInformation,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
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
            runAlignment: WrapAlignment.spaceBetween,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 4.0,
            spacing: 4.0,
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
