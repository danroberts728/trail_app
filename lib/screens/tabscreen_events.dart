import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/widgets/trailevent_monthly_list.dart';
import 'package:flutter/material.dart';

class TabScreenEvents extends StatefulWidget {
  final _TabScreenEvents _state = _TabScreenEvents();
  @override
  State<StatefulWidget> createState() => _state;
}

class _TabScreenEvents extends State<TabScreenEvents> {
  static var now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text(TrailAppSettings.navBarEventsTabTitle),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              MonthlyEventsList(
                month: now,
              ),
              MonthlyEventsList(
                month: DateTime(now.year, now.month + 1),
              ),
              MonthlyEventsList(
                month: DateTime(now.year, now.month + 2),
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
