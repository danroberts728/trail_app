import 'package:alabama_beer_trail/data/check_in.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/screens/screen_trailplaces.dart';
import 'package:alabama_beer_trail/widgets/profile_stat.dart';
import 'package:flutter/material.dart';

class ProfileStatsArea extends StatefulWidget {
  final List<CheckIn> userCheckIns;
  final List<TrailPlace> trailPlaces;

  const ProfileStatsArea({Key key, this.userCheckIns, this.trailPlaces})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileStatsArea();
}

class _ProfileStatsArea extends State<ProfileStatsArea> {
  @override
  Widget build(BuildContext context) {
    List<String> visited = List<String>();
    List<String> notVisited = List<String>();

    if (widget.userCheckIns != null) {
      widget.userCheckIns.forEach((f) {
        if (!visited.contains(f.placeId)) {
          visited.add(f.placeId);
        }
      });
    }
    if (widget.trailPlaces != null) {
      var notVisitedPlaces =
          widget.trailPlaces.where((p) => !visited.contains(p.id)).toList();
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
  }
}
