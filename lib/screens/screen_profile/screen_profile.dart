// Copyright (c) 2020, Fermented Software.
import 'package:beer_trail_app/screens/screen_passport.dart';
import 'package:beer_trail_app/screens/screen_profile/profile_earned_achievements.dart';
import 'package:beer_trail_app/screens/screen_profile/profile_favorites.dart';
import 'package:beer_trail_app/screens/screen_profile/profile_top_area.dart';
import 'package:beer_trail_app/screens/screen_profile/screen_full_activity_log.dart';
import 'package:beer_trail_app/util/trail_app_settings.dart';

import 'package:beer_trail_app/widgets/trail_activity_log.dart';
import 'package:beer_trail_app/widgets/trail_progress_bar.dart';

import 'package:flutter/material.dart';

/// The tab screen for the user's own profile
class ScreenProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScreenProfile();
}

class _ScreenProfile extends State<ScreenProfile> {
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
            ProfileTopArea(),
            // Divider Line
            Divider(
              color: TrailAppSettings.subHeadingColor,
              thickness: 1.0,
              height: 32.0,
            ),
            // Activity header
            Text(
              "Progress",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: TrailAppSettings.mainHeadingColor,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
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
                          .then((value) => setState((){_loadingPassport = false;}));
                },
                child: Text(_loadingPassport
                  ? "Loading..."
                  : "OPEN PASSPORT",
                  style: TextStyle(
                    color: TrailAppSettings.actionLinksColor,
                  ),
                ),
              )
            ),
            // Divider Line
            Divider(
              color: TrailAppSettings.subHeadingColor,
              thickness: 1.0,
              height: 32.0,
            ),
            // Achievements header
            Text(
              "Achievements",
              overflow: TextOverflow.fade,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: TrailAppSettings.mainHeadingColor,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            // Earned Achievements
            ProfileEarnedAchievements(),
            // Divider Line
            Divider(
              color: TrailAppSettings.subHeadingColor,
              thickness: 1.0,
              height: 32.0,
            ),
            // Favorites header
            Text(
              "Favorites",
              overflow: TextOverflow.fade,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: TrailAppSettings.mainHeadingColor,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            // Favorites
            ProfileFavorites(),
            // Divider Line
            Divider(
              color: TrailAppSettings.subHeadingColor,
              thickness: 1.0,
              height: 32.0,
            ),
            // Activity header
            Text(
              "Recent Activity",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: TrailAppSettings.mainHeadingColor,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
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
                  Future.delayed(Duration(milliseconds: 50), () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      settings: RouteSettings(name: 'Full Activity Log'),
                      builder: (context) => ScreenFullActivityLog(),
                    ),
                  ).then((a) => setState(() => _loadingFullActivity = false)));
                },
                child: Text(
                  _loadingFullActivity
                    ? "Loading..."
                    : "SEE ALL",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: TrailAppSettings.actionLinksColor,
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
