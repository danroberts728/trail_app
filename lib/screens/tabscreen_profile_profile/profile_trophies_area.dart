// Copyright (c) 2020, Fermented Software.
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/screens/screen_trailtrophy_detail/screen_trailtrophy_detail.dart';
import 'package:alabama_beer_trail/blocs/profile_trophies_area_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// The trophies area of the Profile tab screen
class ProfileTrophiesArea extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileTrophiesArea();
}

class _ProfileTrophiesArea extends State<ProfileTrophiesArea> {
  final _crossAxisCount = 4;

  final _profileTrophiesAreaBloc = ProfileTrophiesAreaBloc(TrailDatabase());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _profileTrophiesAreaBloc.stream,
      initialData: _profileTrophiesAreaBloc.userTrophyInformation,
      builder: (context, snapshot) {
        List<UserTrophyInformation> data = snapshot.data;
        return SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: this._crossAxisCount,
          ),
          delegate: SliverChildBuilderDelegate((context, index) {
            return InkWell(
              onTap: () {
                Feedback.forTap(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    settings: RouteSettings(
                      name: 'Trail Tophy - ' + data[index].trophy.name,
                    ),
                    builder: (context) => TrophyDetailScreen(
                      trophy: data[index].trophy,
                    ),
                  ),
                );
              },
              child: Container(
                child: CachedNetworkImage(
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  fit: BoxFit.scaleDown,
                  imageUrl: data[index].userEarned
                      ? data[index].trophy.activeImage
                      : data[index].trophy.inactiveImage,
                ),
              ),
            );
          }, childCount: data.length),
        );
      },
    );
  }
}
