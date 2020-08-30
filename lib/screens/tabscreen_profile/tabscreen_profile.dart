import 'package:alabama_beer_trail/screens/tabscreen_profile/profile_trophies_area.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/screens/tabscreen_profile/profile_stats_area.dart';
import 'package:alabama_beer_trail/screens/tabscreen_profile/proflie_top_area.dart';

import '../../util/appauth.dart';

import 'package:flutter/material.dart';

/// The tab screen for the user's own profile
///
class TabScreenProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabScreenProfile();
}

/// The state for the profile tab
class _TabScreenProfile extends State<TabScreenProfile> {
  /// The user's current sign in status
  SigninStatus signinStatus = SigninStatus.NOT_SIGNED_IN;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          // Top Area (images, name, email, member since, about You, and location)
          SliverToBoxAdapter(
            child: ProfileTopArea(),
          ),
          // Divider Line
          SliverToBoxAdapter(
            child: Divider(
              color: TrailAppSettings.second,
            ),
          ),
          // Stats Area
          SliverToBoxAdapter(
            child: ProfileStatsArea(),
          ),
          // Divider Line
          SliverToBoxAdapter(
            child: Divider(
              color: TrailAppSettings.second,
            ),
          ),
          // Trophy header
          SliverToBoxAdapter(
            child: Text(
              "Achievements",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: TrailAppSettings.mainHeadingColor,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Spacer
          SliverToBoxAdapter(
            child: SizedBox(
              height: 16.0,
            ),
          ),
          // Trophy Area
          ProfileTrophiesArea(),
          // Spacer
          SliverToBoxAdapter(
            child: SizedBox(
              height: 80.0,
            ),
          ),
        ],
      ),
    );
  }
}
