import 'dart:math';

import 'package:alabama_beer_trail/blocs/location_bloc.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/data/trail_place_category.dart';
import 'package:alabama_beer_trail/util/filter_options.dart';
import 'package:alabama_beer_trail/util/geo_methods.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/widgets/trailplace_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'modal_trailfilter.dart';

class TrailListView extends StatefulWidget {
  final List<TrailPlace> places;
  final Key key;

  const TrailListView({this.key, this.places}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TrailListViewState();
}

class TrailListViewState extends State<TrailListView> {
  String _searchQuery;
  final _searchController = new TextEditingController();
  bool _showSearchBar = false;
  FilterOptions _filter;
  bool _showUpdate;

  var _locationBloc = LocationBloc();

  void updateSearchQuery(String query) {
    this._searchQuery = query;
  }

  void showSearchBar() {
    setState(() {
      _showSearchBar = true;
    });
  }

  void showFilterModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ModalTrailFilter(initialOptions: this._filter);
      },
    ).then((value) {
      bool doUpdate = false;
      if (this._filter.sort != value.sort) {
        doUpdate = true;
      }
      setState(() {
        this._filter = value;
      });      
      if (doUpdate) {
        _refreshScreen();
      }
    });
  }

  void _refreshScreen() {
    // Clear the screen
    setState(() {
      _showUpdate = true;
    });
    // Sort the places
    sortPlaces();
    // Return the screen
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _showUpdate = false;
      });
    });
  }

  void sortPlaces() {
    if (this._filter.sort == SortOrder.DISTANCE &&
        _locationBloc.hasPermission &&
        _locationBloc.lastLocation != null) {
      widget.places.sort((a, b) {
        return GeoMethods.calculateDistance(
                a.location, _locationBloc.lastLocation)
            .compareTo(GeoMethods.calculateDistance(
                b.location, _locationBloc.lastLocation));
      });
    } else {
      widget.places
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    }
  }

  void _onLocationUpdate(Point<num> newLocation) {
    _refreshScreen();
  }

  @override
  void initState() {
    super.initState();
    var initialShow = Map<TrailPlaceCategory, bool>();
    TrailAppSettings.filterStrings.forEach((f) => initialShow[f] = true);
    this._filter = FilterOptions(SortOrder.DISTANCE, initialShow);

    sortPlaces();
    _showUpdate = false;

    _locationBloc.locationStream.listen(_onLocationUpdate);
  }

  @override
  Widget build(BuildContext context) {
    if (_showUpdate) {
      return Center(child: Center(child: CircularProgressIndicator()));
    } else {
      return RefreshIndicator(
        onRefresh: () {
          _showUpdate = true;
          return _locationBloc.refreshLocation();
        },
        child: Container(
          child: Column(
            children: <Widget>[
              // Search
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                height: _showSearchBar ? 50.0 : 0.0,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Visibility(
                  visible: _showSearchBar,
                  child: TextField(
                    onChanged: (query) {
                      setState(() {
                        _searchQuery = query;
                      });
                    },
                    controller: _searchController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                      suffixIcon: _showSearchBar
                          ? IconButton(
                              icon: Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  _showSearchBar = false;
                                  _searchQuery = "";
                                });
                              },
                            )
                          : null,
                      isDense: true,
                      labelText: '',
                      hintText: '',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                  ),
                ),
              ),
              // ListView
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: widget.places.length,
                    itemBuilder: (BuildContext context, int index) {
                      List<String> filterIncludes = List<String>();
                      _filter.show.forEach((cat, show) {
                        if (show) {
                          filterIncludes.add(cat.name);
                        }
                      });

                      if (!widget.places[index].categories
                          .any((f) => filterIncludes.contains(f))) {
                        // Remove items that don't match filter
                        return Container();
                      } else if (_searchQuery == null ||
                          _searchQuery.isEmpty ||
                          widget.places[index].name
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase())) {
                        // Only include items that match search (or all filtered items if search is not active)
                        return TrailListCard(
                          place: widget.places[index],
                        );
                      } else {
                        // Remove items that don't match search
                        return Container();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
