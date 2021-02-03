// Copyright (c) 2020, Fermented Software.
import 'package:beer_trail_app/blocs/tabscreen_badges_bloc.dart';
import 'package:beer_trail_app/data/trail_database.dart';
import 'package:beer_trail_app/screens/screen_trailtrophy_detail/screen_trailtrophy_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// The Badges Tab
class TabScreenBadges extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabScreenBadges();
}

class _TabScreenBadges extends State<TabScreenBadges> {
  final _crossAxisCount = 3;

  final _tabScreenAchievementsBloc = TabScreenBadgesBloc(TrailDatabase());

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: StreamBuilder(
              stream: _tabScreenAchievementsBloc.userTrophyInformationStream,
              initialData: _tabScreenAchievementsBloc.userTrophyInformation,
              builder: (context, snapshot) {
                List<UserTrophyInformation> trophies = snapshot.data;
                // Show earned trophies first
                trophies.sort((a, b) {
                  if (a.userEarned == b.userEarned)
                    return 0;
                  else if (a.userEarned)
                    return -1;
                  else
                    return 1;
                });
                // Show only earned achievements
                if (trophies.isEmpty) {
                  return Container(
                    margin: EdgeInsets.only(top: 8.0),
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Nothing yet. Start checking in to breweries to earn achievements!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  );
                } else {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return Wrap(
                        alignment: WrapAlignment.start,
                        children: trophies.map(
                          (t) {
                            return InkWell(
                              onTap: () {
                                Feedback.forTap(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    settings: RouteSettings(
                                      name: 'Trail Tophy - ' + t.trophy.name,
                                    ),
                                    builder: (context) => TrophyDetailScreen(
                                      trophy: t.trophy,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(12.0),
                                width: (constraints.maxWidth ~/ _crossAxisCount)
                                    .toDouble(),
                                child: Column(
                                  children: <Widget>[
                                    CachedNetworkImage(
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                      fit: BoxFit.scaleDown,
                                      imageUrl: t.userEarned
                                          ? t.trophy.activeImage
                                          : t.trophy.inactiveImage,
                                    ),
                                    Center(
                                      child: Text(
                                        t.trophy.name,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: t.earnedDate != null,
                                      child: Text(
                                        t.earnedDate != null
                                            ? DateFormat("MMM d, yyyy")
                                                .format(t.earnedDate)
                                            : "",
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      );
                    },
                  );
                }
              }),
        );
      },
    );
  }
}
