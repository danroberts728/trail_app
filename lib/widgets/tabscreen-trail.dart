import 'dart:async';
import 'dart:math';

import 'package:beer_trail_app/util/filteroptions.dart';
import 'package:beer_trail_app/widgets/tabscreenchild.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/trailplace.dart';
import 'traillistitem.dart';
import '../util/currentUserLocation.dart';
import 'modal-trailfilter.dart';

class TabScreenTrail extends StatefulWidget implements TabScreenChild {
  final _TabScreenTrail _state = _TabScreenTrail();

  @override
  State<StatefulWidget> createState() => _state;

  List<IconButton> getAppBarActions() {
    return _state.getAppBarActions();
  }
}

class _TabScreenTrail extends State<TabScreenTrail>
    with AutomaticKeepAliveClientMixin<TabScreenTrail> {
  FilterOptions _filterOptions = FilterOptions(SortOrder.DISTANCE);
  Widget _containerChild = Center(child: CircularProgressIndicator());
  List<TrailPlace> _places = List<TrailPlace>();

  /// Build screen when location data received
  _TabScreenTrail() {
    CurrentUserLocation().getLocation().then((Point p) {
      buildTabScreen();
    });
  }

  void buildTabScreen() {
    setState(() {
      this._containerChild = _buildPlacesStream();
    });
  }

  void filterPressed() {
    var filterSheet = showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ModalTrailFilter(
          initialOptions: this._filterOptions,
        );
      },
    ).then((value) {
      if (value is FilterOptions) {
        this._filterOptions = value;
        setState(() {
          this._containerChild = _buildPlacesStream();
        });
      }
    });
  }

  List<IconButton> getAppBarActions() {
    return <IconButton>[
      IconButton(
        icon: Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            this._containerChild = Center(child: CircularProgressIndicator());
          });          
          this.screenRefresh();
        } 
      ),
      IconButton(
        icon: Icon(Icons.filter_list),
        onPressed: filterPressed,
      ),
    ];
  }

  void sortPlacesByDistance() {
    this._places.sort((TrailPlace a, TrailPlace b) {
      return a.lastClaculatedDistance.compareTo(b.lastClaculatedDistance);
    });
  }

  void sortPlacesByName() {
    this._places.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: EdgeInsets.all(10.0),
      child: RefreshIndicator(
        onRefresh: this.screenRefresh,
        child: _containerChild,
      ),
    );
  }

  Future<void> screenRefresh() {
    return CurrentUserLocation().getLocation().then((Point p) {
      this._updateDistancesWithLastLocation();
      this._sortPlaces();
      setState(() {
        this._containerChild = this._buildPlacesStream();
      });
    });
  }

  StreamBuilder<QuerySnapshot> _buildPlacesStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('places').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text("Error: ${snapshot.error}");
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            this._places = snapshot.data.documents.map<TrailPlace>(
              (DocumentSnapshot document) {
                return TrailPlace(
                  name: document['name'],
                  address: document['address'],
                  city: document['city'],
                  state: document['state'],
                  zip: document['zip'],
                  logoUrl: document['logo_img'],
                  featuredImgUrl: document['featured_img'],
                  categories: List<String>.from(document['categories']),
                  location: Point(document['location'].latitude, document['location'].longitude),
                );
              },
            ).toList();
            this._updateDistancesWithLastLocation();
            this._sortPlaces();            

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: this._places.length,
              itemBuilder: (BuildContext context, int index) {
                List<TrailPlace> p = this._places;
                return new TrailListItem(place: p[index]);
              },
            );
        }
      },
    );
  }

  void _updateDistancesWithLastLocation() {
    Point p = CurrentUserLocation().lastLocation;
    this._places.forEach((element)  => element.calculateDistance(p));
  }

  void _sortPlaces() {
    if (_filterOptions.sort == SortOrder.DISTANCE &&
        CurrentUserLocation().hasPermission)
      sortPlacesByDistance();
    else
      sortPlacesByName();
  }
}
