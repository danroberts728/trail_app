import 'package:alabama_beer_trail/blocs/trail_places_bloc.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/widgets/trailplace_list.dart';
import 'package:flutter/material.dart';

class TrailSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => super.searchFieldLabel;

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
        stream: TrailPlacesBloc().trailPlaceStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<TrailPlace> allPlaces = snapshot.data;
            List<TrailPlace> places = allPlaces
                .where(
                    (p) => p.name.toLowerCase().contains(query.toLowerCase()))
                .toList();
            return TrailListView(
              places: places,
            );
          }
        });
  }
}
