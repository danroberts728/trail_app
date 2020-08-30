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
        List<UserPlaceInformation> userPlacesInformation = snapshot.data;
        List<UserPlaceInformation> visited =
            userPlacesInformation.where((e) => e.userHasCheckedIn).toList();
        List<UserPlaceInformation> notVisited =
            userPlacesInformation.where((e) => !e.userHasCheckedIn).toList();
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
                              placeIds:
                                  userPlacesInformation.map((e) => e.place.id),
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
                              placeIds: notVisited.map((e) => e.place.id),
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
  }
}
