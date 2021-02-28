// Copyright (c) 2020, Fermented Software.
import 'package:beer_trail_app/blocs/profile_earned_achievements_bloc.dart';
import 'package:beer_trail_database/trail_database.dart';
import 'package:beer_trail_database/domain/trail_trophy.dart';
import 'package:beer_trail_app/screens/screen_trailtrophy_detail/screen_trailtrophy_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// A horizontally-scrolled list of the user's earned achievements (trophies)
/// for display in the user's profile
class ProfileEarnedAchievements extends StatelessWidget {
  final ProfileEarnedAchievementsBloc _bloc =
      ProfileEarnedAchievementsBloc(TrailDatabase());

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.stream,
      initialData: _bloc.userEarnedTrophies,
      builder: (context, snapshot) {
        List<TrailTrophy> trophies = snapshot.data;
        if (trophies == null) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child:LinearProgressIndicator(),
          );
        } else if (trophies.isEmpty) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("Nothing yet! Start checking in to breweries to earn achievements",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
          );
        } else {
          return Container(
            padding: EdgeInsets.only(left: 16.0),
            height: 85.0,
            child: Scrollbar(
              controller: _scrollController,
              isAlwaysShown: true,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: trophies.length,
                itemBuilder: (context, index) {
                  TrailTrophy t = trophies[index];
                  return InkWell(
                    onTap: () {
                      Feedback.forTap(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          settings: RouteSettings(
                            name: 'Trail Tophy - ' + t.name,
                          ),
                          builder: (context) => TrophyDetailScreen(
                            trophy: t,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: CachedNetworkImage(
                        imageUrl: t.activeImage,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}