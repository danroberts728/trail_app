// Copyright (c) 2020, Fermented Software.
import 'package:beer_trail_app/bloc/trail_progress_bar_bloc.dart';
import 'package:trail_database/trail_database.dart';
import 'package:beer_trail_app/util/trail_app_settings.dart';
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
                          TrailAppSettings.attentionColor),
                      backgroundColor: Colors.black12),
                ),
                SizedBox(height: 8.0),
                Text(
                  "${progress.uniqueCheckIns} of ${progress.totalPlaces} Stamps",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  progress.percentProgress.isFinite
                      ? "You have visited ${(progress.percentProgress * 100).toStringAsFixed(1)}% of the trail"
                      : "You must be signed in to check in.",
                  maxLines: 3,
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
