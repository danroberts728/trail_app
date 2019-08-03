import 'dart:async';
import 'dart:math';

import 'package:alabama_beer_trail/util/const.dart';
import 'package:alabama_beer_trail/util/filteroptions.dart';
import 'package:alabama_beer_trail/util/trailplacecategory.dart';
import 'package:alabama_beer_trail/widgets/tabscreenchild.dart';
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
  FilterOptions _filterOptions;
  Widget _containerChild = Center(child: CircularProgressIndicator());
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<TrailPlace> _places = List<TrailPlace>();

  /// Build screen when location data received
  _TabScreenTrail() {
    Map<TrailPlaceCategory, bool> initialShow = Map<TrailPlaceCategory, bool>();
    Constants.options.filterStrings.forEach((f) {
      initialShow[f] = true;
    });
    this._filterOptions = FilterOptions(SortOrder.DISTANCE, initialShow);
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ModalTrailFilter(initialOptions: this._filterOptions);
      },
    ).then((value) {
      this._filterOptions = value;
      this._refreshIndicatorKey.currentState.show().then((value) {
        CurrentUserLocation().getLocation().then((Point p) {
          this._containerChild = this._buildPlacesStream();
        });
      });
    });
  }

  List<IconButton> getAppBarActions() {
    return <IconButton>[
      IconButton(
        icon: Icon(Icons.refresh),
        onPressed: () {
          this._refreshIndicatorKey.currentState.show().then((value) {
            CurrentUserLocation().getLocation().then((Point p) {
              this._containerChild = this._buildPlacesStream();
            });
          });
        },
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
        key: this._refreshIndicatorKey,
        onRefresh: this.screenRefresh,
        child: _containerChild,
      ),
    );
  }

  Future<void> screenRefresh() {
    return CurrentUserLocation().getLocation().then((Point p) {
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
                  location: Point(document['location'].latitude,
                      document['location'].longitude),
                );
              },
            ).toList();
            this._updateDistancesWithLastLocation();
            this._sortPlaces();

            Set<TrailPlace> placesShown = Set<TrailPlace>();
            this._filterOptions.show.forEach((cat, show) {
              if (show) {
                this._places.forEach((p) {
                  if (p.categories.contains(cat.name)) {
                    placesShown.add(p);
                  }
                });
              }
            });

            if (placesShown.length == 0) {
              return Center(
                child: Text(
                  "Nothing matched your criteria. Try expanding the search filter.",
                  textAlign: TextAlign.center,
                ),
              );
            }

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: placesShown.length,
              itemBuilder: (BuildContext context, int index) {
                List<TrailPlace> p = placesShown.toList();
                return new TrailListItem(place: p[index]);
              },
            );
        }
      },
    );
  }

  void _updateDistancesWithLastLocation() {
    Point p = CurrentUserLocation().lastLocation;
    this._places.forEach((element) =>
        element.lastClaculatedDistance = element.calculateDistance(p));
  }

  void _sortPlaces() {
    if (_filterOptions.sort == SortOrder.DISTANCE &&
        CurrentUserLocation().hasPermission)
      sortPlacesByDistance();
    else
      sortPlacesByName();
  }
}
