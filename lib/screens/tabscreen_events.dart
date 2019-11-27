import 'package:alabama_beer_trail/widgets/trailevent_monthly_list.dart';
import 'package:flutter/material.dart';

class TabScreenEvents extends StatefulWidget {
  final _TabScreenEvents _state = _TabScreenEvents();
  @override
  State<StatefulWidget> createState() => _state;
}

class _TabScreenEvents extends State<TabScreenEvents> {
  var _now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshPulled,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              MonthlyEventsList(
                month: _now,
              ),
              MonthlyEventsList(
                month: DateTime(_now.year, _now.month + 1),
              ),
              MonthlyEventsList(
                month: DateTime(_now.year, _now.month + 2),
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refreshPulled() {
    return Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _now = DateTime.now();
      });
    });
  }
}
