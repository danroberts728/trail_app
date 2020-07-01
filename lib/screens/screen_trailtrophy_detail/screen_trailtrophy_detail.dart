import 'package:alabama_beer_trail/data/trail_trophy.dart';
import 'package:alabama_beer_trail/screens/screen_trailtrophy_detail/progress_exact_unique_checkins.dart';
import 'package:alabama_beer_trail/screens/screen_trailtrophy_detail/progress_pct_unique_of_total.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrophyDetailScreen extends StatelessWidget {
  final TrailTrophy trophy;

  TrophyDetailScreen({Key key, this.trophy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(trophy.name)),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 16.0,
              ),
              Center(
                child: CachedNetworkImage(
                  fit: BoxFit.contain,
                  imageUrl: trophy.activeImage,
                ),
              ),
              Center(
                child: Text(
                  trophy.name,
                  style: TextStyle(
                    fontSize: 22.0,
                    color: TrailAppSettings.mainHeadingColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Center(
                child: Text(
                  trophy.description,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontStyle: FontStyle.italic,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Divider(
                color: TrailAppSettings.second,
              ),
              Center(
                child: Text(
                  "Progress",
                  style: TextStyle(
                    color: TrailAppSettings.subHeadingColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Builder(
                builder: (context) {
                  if (trophy.trophyType == TrophyType.ExactUniqueCheckins) {
                    return TrailTrophyProgressExactUniqueCheckins(
                      trophy: trophy,
                    );
                  } else if (trophy.trophyType ==
                      TrophyType.PercentUniqueOfTotal) {
                    return TrailTrophyProgressPctUniqueOfTotal(
                      trophy: trophy,
                    );
                  } else {
                    return null;
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
