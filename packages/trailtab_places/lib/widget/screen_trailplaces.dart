// Copyright (c) 2021, Fermented Software.
import 'package:trail_database/trail_database.dart';
import 'package:trailtab_places/bloc/screen_trailplaces_bloc.dart';
import 'package:trail_location_service/trail_location_service.dart';
import 'package:trailtab_places/widget/trailplace_list.dart';
import 'package:flutter/material.dart';

class TrailPlacesScreen extends StatefulWidget {
  final List<String> placeIds;
  final String appBarTitle;

  TrailPlacesScreen({@required this.placeIds, @required this.appBarTitle});

  @override
  State<StatefulWidget> createState() => _TrailPlacesScreen();
}

class _TrailPlacesScreen extends State<TrailPlacesScreen> {
  ScreenTrailListBloc _screenTrailListBloc = ScreenTrailListBloc(TrailDatabase());

  _TrailPlacesScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle),
      ),
      body: StreamBuilder(
        stream: _screenTrailListBloc.trailPlaceStream,
        initialData: _screenTrailListBloc.trailPlaces,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Icon(Icons.error));
          } else {
            var placesToShow = (snapshot.data as List<TrailPlace>)
                .where((p) => widget.placeIds.contains(p.id))
                .toList();
            placesToShow.sort((a, b) {
              if (TrailLocationService().lastLocation != null) {
                var userLocation = TrailLocationService().lastLocation;
                return GeoMethods.calculateDistance(a.location, userLocation)
                    .compareTo(
                        GeoMethods.calculateDistance(b.location, userLocation));
              } else {
                return a.name.compareTo(b.name);
              }
            });
            return TrailList(
              places: placesToShow.toList(),
            );
          }
        },
      ),
    );
  }
}
