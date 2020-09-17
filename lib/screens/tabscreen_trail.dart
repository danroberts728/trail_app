import 'package:alabama_beer_trail/screens/tabscreen_trail_list.dart';
import 'package:alabama_beer_trail/screens/tabscreen_trail_map.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:flutter/material.dart';

/// The tab screen for the Trail
/// 
class TabScreenTrail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabScreenTrail();
}

/// The state for the trail tab
/// 
class _TabScreenTrail extends State<TabScreenTrail>
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
            indicatorColor: TrailAppSettings.actionLinksColor,
            indicatorWeight: 4.0,
            labelColor: TrailAppSettings.subHeadingColor,
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
