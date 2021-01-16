// Copyright (c) 2020, Fermented Software.
import 'package:alabama_beer_trail/blocs/trail_activity_log_bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/model/activity_item.dart';
import 'package:alabama_beer_trail/widgets/trail_activity_card.dart';
import 'package:flutter/material.dart';

/// A widget that shows a list of trail activity
class TrailActivityLog extends StatelessWidget {
  final int limit;

  TrailActivityLog({Key key, this.limit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TrailActivityLogBloc _bloc = TrailActivityLogBloc(TrailDatabase(), limit);
    return StreamBuilder(
      stream: _bloc.stream,
      initialData: _bloc.activities,
      builder: (context, snapshot) {
        List<ActivityItem> activities = snapshot.data;
        if (activities.length == 0) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "You have no activity.",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          );
        } else {
          return Container(
            width: double.infinity,
            child: Column(
              children: activities.map(
                (activity) {
                  return TrailActivityCard(activity: activity);
                },
              ).toList(),
            ),
          );
        }
      },
    );
  }
}
