import 'package:alabama_beer_trail/screens/tabscreen_child.dart';
import 'package:alabama_beer_trail/widgets/monthly_event_list.dart';
import 'package:flutter/material.dart';

class TabScreenEvents extends StatefulWidget implements TabScreenChild {
  final _TabScreenEvents _state = _TabScreenEvents();
  @override
  State<StatefulWidget> createState() => _state;

  @override
  List<IconButton> getAppBarActions() {
    return _state.getAppBarActions();
  }
}

class _TabScreenEvents extends State<TabScreenEvents> {
  static var now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();

    return Container(
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
    );
  }

  List<IconButton> getAppBarActions() {
    return List<IconButton>();
  }
}
