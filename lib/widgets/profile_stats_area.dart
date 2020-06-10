import 'package:alabama_beer_trail/blocs/trail_places_bloc.dart';
import 'package:alabama_beer_trail/blocs/user_checkins_bloc.dart';
import 'package:alabama_beer_trail/data/check_in.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/screens/screen_trailplaces.dart';
import 'package:alabama_beer_trail/widgets/profile_stat.dart';
import 'package:flutter/material.dart';

class ProfileStatsArea extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileStatsArea();
}

class _ProfileStatsArea extends State<ProfileStatsArea> {
  // User Checkins BLoC
  UserCheckinsBloc _userCheckinsBloc = UserCheckinsBloc();

  // Trail Places BLoC
  TrailPlacesBloc _trailPlacesBloc = TrailPlacesBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: this._userCheckinsBloc.checkInStream,
      builder: (context, checkInsSnapshot) {
        return StreamBuilder(
          stream: this._trailPlacesBloc.trailPlaceStream,
          builder: (context, placesSnapshot) {
            List<String> visited = List<String>();
            List<String> notVisited = List<String>();

            if (checkInsSnapshot.connectionState == ConnectionState.active &&
                placesSnapshot.connectionState == ConnectionState.active) {
              List<CheckIn> sData = checkInsSnapshot.data as List<CheckIn>;

              sData.forEach((f) {
                if (!visited.contains(f.placeId)) {
                  visited.add(f.placeId);
                }
              });
              var notVisitedPlaces = (placesSnapshot.data as List<TrailPlace>)
                  .where((p) => !visited.contains(p.id))
                  .toList();
              notVisitedPlaces.forEach((p) {
                notVisited.add(p.id);
              });
            }
            return Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: ProfileStat(
                          value: visited.length,
                          postText: "Visited",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                settings: RouteSettings(name: 'Visited'),
                                builder: (context) => TrailPlacesScreen(
                                  appBarTitle: "Visited",
                                  placeIds: visited,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Center(
                        child: ProfileStat(
                          value: notVisited.length,
                          postText: "Not Visited",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                settings: RouteSettings(name: 'Not Visisted'),
                                builder: (context) => TrailPlacesScreen(
                                  appBarTitle: "Not Visited",
                                  placeIds: notVisited,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
