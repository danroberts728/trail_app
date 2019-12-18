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
                onEmpty: _onCurrentMonthEmpty,
              ),
              MonthlyEventsList(
                month: DateTime(_now.year, _now.month + 1),
                onEmpty: _onNextMonthEmpty,
              ),
              MonthlyEventsList(
                month: DateTime(_now.year, _now.month + 2),
                onEmpty: _onNextNextMonthEmpty,
              ),
              Visibility(
                visible: _isCurrentMonthEmpty &&
                    _isNextMonthEmpty &&
                    _isNextNextMonthEmpty,
                child: Center(
                  child: Container(
                    margin: EdgeInsets.all(50.0),
                    child: Text(
                      "There are currently no upcoming events scheduled",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
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
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("Events list updated.")));
      });
    });
  }

  bool _isCurrentMonthEmpty = false;
  bool _isNextMonthEmpty = false;
  bool _isNextNextMonthEmpty = false;

  void _onCurrentMonthEmpty() {
    _isCurrentMonthEmpty = true;
  }

  void _onNextMonthEmpty() {
    _isNextMonthEmpty = true;
  }

  void _onNextNextMonthEmpty() {
    _isNextNextMonthEmpty = true;
  }
}
