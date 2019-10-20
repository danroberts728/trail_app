import 'package:alabama_beer_trail/blocs/trail_places_bloc.dart';
import 'package:alabama_beer_trail/data/trailplace.dart';
import 'package:alabama_beer_trail/widgets/trail_listview.dart';
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
                .where((p) => this.placeIds.contains(p.id));
            return TrailListView(
              places: placesToShow.toList(),
            );
          }
        },
      ),
    );
  }
}
