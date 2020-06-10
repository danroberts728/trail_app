import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/widgets/profile_stats_area.dart';
import 'package:alabama_beer_trail/widgets/proflie_top_area.dart';

import '../blocs/appauth_bloc.dart';

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
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Top Area (images, name, email, member since, about You, and location)
            ProfileTopArea(),
            // Divider Line
            Divider(
              color: TrailAppSettings.second,
              indent: 16.0,
              endIndent: 16.0,
            ),
            // Stats Area
            ProfileStatsArea(),
            // Divider Line
            Divider(
              color: TrailAppSettings.second,
              indent: 16.0,
              endIndent: 16.0,
            ),
            // Trophy Area
          ],
        ),
      ),
    );
  }
}
