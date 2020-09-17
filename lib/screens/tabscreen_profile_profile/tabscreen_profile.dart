import 'package:alabama_beer_trail/screens/tabscreen_profile_profile/profile_trophies_area.dart';
import 'package:alabama_beer_trail/util/tabselection_service.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/screens/tabscreen_profile_profile/profile_stats_area.dart';
import 'package:alabama_beer_trail/screens/tabscreen_profile_profile/proflie_top_area.dart';

import '../../util/appauth.dart';

import 'package:flutter/material.dart';

/// The tab screen for the user's own profile
///
class TabScreenProfileProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabScreenProfileProfile();
}

/// The state for the profile tab
class _TabScreenProfileProfile extends State<TabScreenProfileProfile> {
  /// The user's current sign in status
  SigninStatus signinStatus = SigninStatus.NOT_SIGNED_IN;

  ScrollController _controller = ScrollController();

  TabSelectionService _tabSelectionService = TabSelectionService();

  _TabScreenProfileProfile() {
    _tabSelectionService.tabSelectionStream.listen(_scrollToTop);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        controller: _controller,
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

  void _scrollToTop(newTab) {
    if (newTab == 3 && _tabSelectionService.lastTapSame) {
      _controller.animateTo(0.0,
          duration:
              Duration(milliseconds: _controller.position.pixels ~/ 2),
          curve: Curves.easeOut);
    }
  }
}
