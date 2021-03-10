// Copyright (c) 2021, Fermented Software.
import 'dart:math';

import 'package:trail_location_service/trail_location_service.dart';
import 'package:trail_database/domain/trail_place.dart';
import 'package:beer_trail_app/model/trail_place_category.dart';
import 'package:beer_trail_app/util/trail_app_settings.dart';
import 'package:trailtab_places/trailtab_places.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TrailList extends StatefulWidget {
  final List<TrailPlace> places;
  final Key key;

  const TrailList({this.key, this.places}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TrailListState();
}

class TrailListState extends State<TrailList> {
  bool _showUpdate;

  final ScrollController _controller = ScrollController();

  void scrollToTop() {
    _controller.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  var _locationBloc = TrailLocationService();

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
                        return TrailPlaceCard(
                          key: ValueKey(widget.places[index].id),
                          place: widget.places[index],
                        );
                      },
                  ),
                )
              ),
            ],
          ),
        ),
      );
    }
  }
}
