import 'package:alabama_beer_trail/util/location_service.dart';
import 'package:alabama_beer_trail/blocs/screen_trailplaces_bloc.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/util/geo_methods.dart';
import 'package:alabama_beer_trail/widgets/trailplace_list.dart';
import 'package:flutter/material.dart';

class TrailPlacesScreen extends StatefulWidget {
  final List<String> placeIds;
  final String appBarTitle;

  TrailPlacesScreen({@required this.placeIds, @required this.appBarTitle});

  @override
  State<StatefulWidget> createState() => _TrailPlacesScreen();
}

class _TrailPlacesScreen extends State<TrailPlacesScreen> {
  ScreenTrailListBloc _screenTrailListBloc = ScreenTrailListBloc();

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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Icon(Icons.error));
          } else {
            var placesToShow = (snapshot.data as List<TrailPlace>)
                .where((p) => widget.placeIds.contains(p.id))
                .toList();
            placesToShow.sort((a, b) {
              if (LocationService().lastLocation != null) {
                var userLocation = LocationService().lastLocation;
                return GeoMethods.calculateDistance(a.location, userLocation)
                    .compareTo(
                        GeoMethods.calculateDistance(b.location, userLocation));
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
