import 'package:alabama_beer_trail/blocs/location_bloc.dart';
import 'package:alabama_beer_trail/blocs/trail_places_bloc.dart';
import 'package:alabama_beer_trail/data/trailplace.dart';
import 'package:alabama_beer_trail/util/geomethods.dart';
import 'package:alabama_beer_trail/widgets/trailplace_list.dart';
import 'package:flutter/material.dart';

class TrailPlacesScreen extends StatefulWidget {
  final List<String> placeIds;
  final String appBarTitle;

  TrailPlacesScreen({@required this.placeIds, @required this.appBarTitle});

  @override
  State<StatefulWidget> createState() => _TrailPlacesScreen(this.placeIds, this.appBarTitle);
}

class _TrailPlacesScreen extends State<TrailPlacesScreen> {
  final List<String> placeIds;
  final String appBarTitle;
  TrailPlacesBloc _trailPlacesBloc = TrailPlacesBloc();

  _TrailPlacesScreen(this.placeIds, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: Text(this.appBarTitle),
      ),
      body: StreamBuilder(
        stream: _trailPlacesBloc.trailPlaceStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            var placesToShow = (snapshot.data as List<TrailPlace>)
                .where((p) => this.placeIds.contains(p.id)).toList();
            placesToShow.sort((a,b) {
              if(LocationBloc().lastLocation != null) {
                var userLocation = LocationBloc().lastLocation;
                return GeoMethods.calculateDistance(a.location,userLocation)
                  .compareTo(GeoMethods.calculateDistance(b.location, userLocation));
              } else {
                return a.name.compareTo(b.name);
              }
            });
            return TrailListView(
              places: placesToShow.toList(),
            );
          }
        },
      ),
    );
  }
}
