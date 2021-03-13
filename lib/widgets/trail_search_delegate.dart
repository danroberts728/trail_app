// Copyright (c) 2021, Fermented Software.
import 'package:trail_database/trail_database.dart';
import 'package:trail_database/domain/trail_place.dart';
import 'package:trailtab_places/trailtab_places.dart';
import 'package:flutter/material.dart';

class TrailSearchDelegate extends SearchDelegate {
  final List<TrailPlace> _places = TrailDatabase().places;

  @override
  String get searchFieldLabel => super.searchFieldLabel;

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
      ),
    );
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
    var result = _places
        .where((p) =>
            p.name.toLowerCase().contains(query.toLowerCase()) ||
            p.city.toLowerCase().contains(query.toLowerCase()) ||
            p.address.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return TrailList(
      places: result,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.length < 3) {
      return Container();
    }
    var result = _places
        .where((p) =>
            p.name.toLowerCase().contains(query.toLowerCase()) ||
            p.city.toLowerCase().contains(query.toLowerCase()) ||
            p.address.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return Container(
        width: double.infinity,
        child: ListView.builder(
          itemCount: result.length,
          itemBuilder: (context, index) => InkWell(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(8.0),
              child: Text(
                result[index].name,
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
            ),
            onTap: () {
              Future.delayed(Duration(milliseconds: 300)).then((value) =>
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          settings: RouteSettings(
                            name: 'Trail Place - ' + result[index].name,
                          ),
                          builder: (context) =>
                              TrailPlaceDetailScreen(place: result[index]))));
            },
          ),
        ));
  }
}
