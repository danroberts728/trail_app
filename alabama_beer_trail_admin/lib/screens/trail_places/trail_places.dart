import 'package:beer_trail_admin/screens/trail_places/trail_place_item.dart';
import 'package:beer_trail_admin/screens/trail_places/trail_places_bloc.dart';
import 'package:flutter/material.dart';
import 'package:trail_database/domain/trail_place.dart';

class TrailPlaces extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TrailPlaces();
}

class _TrailPlaces extends State<TrailPlaces> {
  TrailPlacesBloc _bloc = TrailPlacesBloc();

  TextEditingController _searchController;

  String _searchText = "";

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => StreamBuilder(
        stream: _bloc.stream,
        initialData: _bloc.places,
        builder: (context, snapshot) {
          List<TrailPlace> places = snapshot.data;
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  margin: EdgeInsets.all(8.0),
                  padding: EdgeInsets.all(8.0),
                  width: double.infinity,
                  child: TextFormField(
                    decoration: InputDecoration(
                      helperText: "Search",
                      labelText: "Search by name or city",
                    ),
                    controller: _searchController,
                    onChanged: (String text) {
                      setState(() {
                        _searchText = text;
                      });
                    },
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  children: places
                      .where((p) => p.name.toLowerCase().contains(_searchText.trim().toLowerCase()) 
                        || p.city.toLowerCase().contains(_searchText.trim().toLowerCase()))
                      .map<Widget>((p) => SizedBox(
                          width: constraints.maxWidth / 4,
                          child: TrailPlaceItem(
                            place: p,
                          )))
                      .toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
