// Copyright (c) 2020, Fermented Software.
import 'package:alabama_beer_trail/blocs/trail_progress_bar_bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:flutter/material.dart';

/// A widget that shows progress on the trail, including a progress
/// bar, # out of #, and a percentage.
class TrailProgressBar extends StatelessWidget {
  final TrailProgressBarBloc _trailProgressBarBloc =
      TrailProgressBarBloc(TrailDatabase());
  final EdgeInsetsGeometry padding;

  final _defaultPadding  = EdgeInsets.symmetric(horizontal: 16.0);

  TrailProgressBar({Key key, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _trailProgressBarBloc.stream,
        initialData: _trailProgressBarBloc.progressInformation,
        builder: (context, snapshot) {
          ProgressInformation progress = snapshot.data;
          return Container(
            padding: padding != null ? padding : _defaultPadding,
            child: Column(
              children: [
                Container(                  
                  child: LinearProgressIndicator(
                      minHeight: 20.0,
                      value: snapshot.data.percentProgress.isFinite
                          ? snapshot.data.percentProgress
                          : 0,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          TrailAppSettings.subHeadingColor),
                      backgroundColor: Colors.grey),
                ),
                SizedBox(height: 8.0),
                Text(
                  "${progress.uniqueCheckIns} of ${progress.totalPlaces} places",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  progress.percentProgress.isFinite
                      ? "You have checked into ${(progress.percentProgress * 100).toStringAsFixed(1)}% of the trail"
                      : "You must be signed in to check in.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
