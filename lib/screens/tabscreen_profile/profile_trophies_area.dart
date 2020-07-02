import 'package:alabama_beer_trail/data/trail_trophy.dart';
import 'package:alabama_beer_trail/data/user_data.dart';
import 'package:alabama_beer_trail/screens/screen_trailtrophy_detail/screen_trailtrophy_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileTrophiesArea extends StatefulWidget {
  final List<TrailTrophy> trailTrophies;
  final UserData userData;

  const ProfileTrophiesArea({Key key, this.trailTrophies, this.userData})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileTrophiesArea();
}

class _ProfileTrophiesArea extends State<ProfileTrophiesArea> {
  final _crossAxisCount = 4;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: this._crossAxisCount,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        return GestureDetector(
          onTap: () {
            Feedback.forTap(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    settings: RouteSettings(
                      name: 'Trail Tophy - ' + widget.trailTrophies[index].name,
                    ),
                    builder: (context) => TrophyDetailScreen(
                        trophy: widget.trailTrophies[index])));
          },
          child: Container(
            decoration: BoxDecoration(
              color: index % 2 == 0 ? Colors.red : Colors.blue,
            ),
            child: CachedNetworkImage(
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                        CircularProgressIndicator(value: downloadProgress.progress),
              fit: BoxFit.scaleDown,
              imageUrl: widget.userData.trophies.keys
                      .contains(widget.trailTrophies[index].id)
                  ? widget.trailTrophies[index].activeImage
                  : widget.trailTrophies[index].inactiveImage,
            ),
          ),
        );
      }, childCount: widget.trailTrophies.length),
    );
  }
}
