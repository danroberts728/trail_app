// Copyright (c) 2020, Fermented Software.
import 'dart:math' as math;

import 'package:alabama_beer_trail/blocs/tabscreen_achievements_bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/screens/screen_trailtrophy_detail/screen_trailtrophy_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// The Achievements Tab
class TabScreenAchievements extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabScreenAchievements();
}

class _TabScreenAchievements extends State<TabScreenAchievements> {
  final _crossAxisCount = 3;

  final _tabScreenAchievementsBloc = TabScreenAchievementsBloc(TrailDatabase());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder(
        stream: _tabScreenAchievementsBloc.stream,
        initialData: _tabScreenAchievementsBloc.userTrophyInformation,
        builder: (context, snapshot) {
          List<UserTrophyInformation> trophies = snapshot.data;
          // Show earned achievements first    
          trophies.sort((a, b) {
            if (a.userEarned == b.userEarned)
              return 0;
            else if (a.userEarned)
              return -1;
            else
              return 1;
          });
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
                        width: (constraints.maxWidth ~/ _crossAxisCount).toDouble(),
                        child: Column(
                          children: <Widget>[
                            CachedNetworkImage(
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
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
                                  //color: TrailAppSettings.actionLinksColor,
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
                            SizedBox(
                              height: 0.0,
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
        },
      ),
    );
  }
}
