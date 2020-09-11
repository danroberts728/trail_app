import 'dart:async';

import 'package:alabama_beer_trail/util/place_filter_service.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlaceFilterFab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlaceFilterFab();
}

class _PlaceFilterFab extends State<PlaceFilterFab>
    with SingleTickerProviderStateMixin {
  StreamSubscription _filterStreamSubscription;
  _PlaceFilterFab() {
    _filterStreamSubscription = PlaceFilterService().stream.listen((event) {
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Center(
            child: Icon(
              FontAwesomeIcons.filter,
              color: PlaceFilterService().anyCategoriesFalse()
                  ? TrailAppSettings.attentionColor
                  : Colors.white,
            ),
          ),
          Visibility(
            visible: PlaceFilterService().filter.hoursOption != HoursOption.ALL,
            child: Positioned(
              top: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white70,
                ),
                child: Center(
                  child: Icon(
                    Icons.access_time,
                    color: TrailAppSettings.attentionColor,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _filterStreamSubscription.cancel();
    super.dispose();
  }
}
