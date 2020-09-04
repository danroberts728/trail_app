import 'dart:math';

import 'package:alabama_beer_trail/util/location_service.dart';
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
  FilterOptions _filter;
  bool _showUpdate;

  final ScrollController _controller = ScrollController();

  void scrollToTop() {
    _controller.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  var _locationBloc = LocationService();

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
    if(!this.mounted) {
      return;
    }
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
    // Only refresh the screen if the user pulled
    // to refresh.
    if(_showUpdate) {
      _refreshScreen();
    }    
  }

  Future<void> _refreshPulled() {
    setState(() {
      _showUpdate = true;
    });
    return _locationBloc.refreshLocation().timeout(Duration(seconds: 5),
      onTimeout: () {
        setState(() {
          _showUpdate = false;
        });
        return null;
    });
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
        onRefresh: _refreshPulled,
        child: Container(
          color: Colors.black12,
          child: Column(
            children: <Widget>[
              // ListView
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0.0),
                  child: ListView.builder(
                    controller: _controller,
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
                      } else {
                        return TrailPlaceCard(
                          key: ValueKey(widget.places[index].id),
                          place: widget.places[index],
                        );
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
