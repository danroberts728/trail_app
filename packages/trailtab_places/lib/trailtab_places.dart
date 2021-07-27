// Copyright (c) 2020, Fermented Software.
library tabscreen_places;
export 'package:trailtab_places/widget/screen_trailplace_detail.dart';
export 'package:trailtab_places/widget/trailplace_header.dart';
export 'package:trailtab_places/widget/stamped_place_icon.dart';
export 'package:trailtab_places/widget/trailplace_card.dart';
export 'package:trailtab_places/widget/trail_passport.dart';
export 'package:trailtab_places/widget/guild_badge.dart';
export 'package:trailtab_places/widget/screen_passport.dart';
export 'package:trailtab_places/widget/screen_trailplaces.dart';
export 'package:trailtab_places/widget/trailplace_list.dart';

import 'package:trailtab_places/util/trailtab_places_settings.dart';
import 'package:trailtab_places/widget/tabscreen_trail_list.dart';
import 'package:trailtab_places/widget/tabscreen_trail_map.dart';
import 'package:flutter/material.dart';

/// The tab screen for the Trail
/// 
class TrailTabPlaces extends StatefulWidget {
  final double minDistanceToCheckIn;
  final bool showNonMemberTapList;
  final String membershipLogoAsset;

  TrailTabPlaces({Key key, this.minDistanceToCheckIn = 0.15, this.showNonMemberTapList = false, this.membershipLogoAsset = ''}) : super(key: key) {
    TrailTabPlacesSettings().minDistanceToCheckIn = this.minDistanceToCheckIn;
    TrailTabPlacesSettings().showNonMemberTapList = showNonMemberTapList;
    TrailTabPlacesSettings().membershipLogoAsset = membershipLogoAsset;
  }
  @override
  State<StatefulWidget> createState() => _TrailTabPlaces();
}

/// The state for the trail tab
/// 
class _TrailTabPlaces extends State<TrailTabPlaces>
    with SingleTickerProviderStateMixin {

  /// The controller for the sub-tab
  /// 
  /// The tabs switch between the list and map screens
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          child: TabBar(
            isScrollable: false,
            labelPadding: EdgeInsets.symmetric(vertical: 0.0),
            indicatorColor: Theme.of(context).buttonColor,
            indicatorWeight: 4.0,
            labelColor: Theme.of(context).textTheme.subtitle1.color,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            controller: _controller,
            tabs: <Widget>[Tab(text: "List"), Tab(text: "Map")],
          ),
        ),
        Expanded(
          child: Container(
            child: TabBarView(
              controller: _controller,
              children: <Widget>[
                TabScreenTrailList(),
                TabScreenTrailMap(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
