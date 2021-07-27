library trail_profile;

// Copyright (c) 2020, Fermented Software.
import 'package:trail_profile/widget/trail_progress_bar.dart';
import 'package:trailtab_places/trailtab_places.dart';
import 'package:trail_profile/widget/profile_earned_achievements.dart';
import 'package:trail_profile/widget/profile_favorites.dart';
import 'package:trail_profile/widget/profile_top_area.dart';
import 'package:trail_profile/widget/screen_full_activity_log.dart';

import 'package:trail_profile/widget/trail_activity_log.dart';

import 'package:flutter/material.dart';

/// The tab screen for the user's own profile
class TrailProfile extends StatefulWidget {
  final String defaultProfilePhotoAssetName;
  final String defaultBannerImageAssetName;
  final String defaultDisplayName;

  TrailProfile(
      {@required this.defaultProfilePhotoAssetName,
      @required this.defaultBannerImageAssetName,
      @required this.defaultDisplayName});

  @override
  State<StatefulWidget> createState() => _TrailProfile();
}

class _TrailProfile extends State<TrailProfile> {
  final ScrollController _controller = ScrollController();

  bool _loadingFullActivity = false;
  bool _loadingPassport = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Profile"),
      ),
      body: SingleChildScrollView(
        controller: _controller,
        child: Column(
          children: <Widget>[
            // Top Area (images, name, email, member since, about You, and location)
            ProfileTopArea(
              defaultBannerImageAssetName: widget.defaultBannerImageAssetName,
              defaultProfilePhotoAssetName: widget.defaultProfilePhotoAssetName,
              defaultDisplayName: widget.defaultDisplayName,
            ),
            // Divider Line
            Divider(
              color: Theme.of(context).textTheme.subtitle1.color,
              thickness: 1.0,
              height: 32.0,
            ),
            // Activity header
            Text(
              "Progress",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline2,
            ),
            SizedBox(height: 8.0),
            // Progress Bar
            TrailProgressBar(),
            Container(
                width: double.infinity,
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    setState(() => _loadingPassport = true);
                    Feedback.forTap(context);
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                settings: RouteSettings(
                                  name: 'Passport',
                                ),
                                builder: (context) => ScreenPassport()))
                        .then((value) => setState(() {
                              _loadingPassport = false;
                            }));
                  },
                  child: Text(
                    _loadingPassport ? "Loading..." : "OPEN PASSPORT",
                    style: TextStyle(
                      color: Theme.of(context).buttonColor,
                    ),
                  ),
                )),
            // Divider Line
            Divider(
              color: Theme.of(context).textTheme.subtitle1.color,
              thickness: 1.0,
              height: 32.0,
            ),
            // Achievements header
            Text(
              "Achievements",
              overflow: TextOverflow.fade,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).textTheme.subtitle1.color,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            // Earned Achievements
            ProfileEarnedAchievements(),
            // Divider Line
            Divider(
              color: Theme.of(context).textTheme.subtitle1.color,
              thickness: 1.0,
              height: 32.0,
            ),
            // Favorites header
            Text(
              "Favorites",
              overflow: TextOverflow.fade,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline2,
            ),
            SizedBox(height: 8.0),
            // Favorites
            ProfileFavorites(),
            // Divider Line
            Divider(
              color: Theme.of(context).textTheme.subtitle1.color,
              thickness: 1.0,
              height: 32.0,
            ),
            // Activity header
            Text(
              "Recent Activity",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline2,
            ),
            SizedBox(height: 8.0),
            // Activity Log
            TrailActivityLog(
              limit: 5,
            ),
            // Spacer
            SizedBox(
              height: 16.0,
            ),
            // See All Activity
            Container(
              width: double.infinity,
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: TextButton(
                onPressed: () {
                  setState(() => _loadingFullActivity = true);
                  Future.delayed(
                      Duration(milliseconds: 50),
                      () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              settings:
                                  RouteSettings(name: 'Full Activity Log'),
                              builder: (context) => ScreenFullActivityLog(),
                            ),
                          ).then((a) =>
                              setState(() => _loadingFullActivity = false)));
                },
                child: Text(
                  _loadingFullActivity ? "Loading..." : "SEE ALL",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Theme.of(context).buttonColor,
                  ),
                ),
              ),
            ),
            // Spacer
            SizedBox(
              height: 16.0,
            ),
          ],
        ),
      ),
    );
  }
}
