import 'dart:async';

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
  bool _sortByDistance = true;
  Widget _containerChild = Center(child: CircularProgressIndicator());
  List<TrailPlace> _places = List<TrailPlace>();

  /// Build screen when location data received
  ///
  /// Note that the CurrentLocation stream may return an invalid point, particularly
  /// if the user does not have location turned on.
  ///
  /// After the initial location is received, it will not receive further location
  /// updates.
  _TabScreenTrail() {
    StreamSubscription subscription;
    subscription =
        CurrentUserLocation().streamBroadcast.stream.listen((Point p) {
      buildTabScreen();
      subscription.cancel();
    });
  }

  void buildTabScreen() {
    setState(() {
      this._containerChild = _buildPlacesStream();
    });
  }

  void filterPressed() {

    showModalBottomSheet<FilterOptions>(
      context: context,
      builder: (BuildContext context) {
        return ModalTrailFilter(); 
      },
    ).then((FilterOptions options) {

    });
  }

  List<IconButton> getAppBarActions() {
    return <IconButton>[
      IconButton(
        icon: Icon(Icons.filter_list),
        onPressed: filterPressed,
      )
    ];
  }

  void sortPlacesByDistance() {
    GeoPoint p = GeoPoint(
        CurrentUserLocation().latitude, CurrentUserLocation().longitude);
    this._places.sort((TrailPlace a, TrailPlace b) {
      double distA = TrailPlace.calculateDistance(
          GeoPoint(p.latitude, p.longitude),
          GeoPoint(a.location.latitude, a.location.longitude));
      double distB = TrailPlace.calculateDistance(
          GeoPoint(p.latitude, p.longitude),
          GeoPoint(b.location.latitude, b.location.longitude));
      a.distance = TrailPlace.toFriendlyDistanceString(distA);
      b.distance = TrailPlace.toFriendlyDistanceString(distB);
      return distA.compareTo(distB);
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
    return Future<void>.delayed(Duration(seconds: 1), () {
      _sortPlaces();
      var newPlaces = List<TrailPlace>();
      newPlaces.addAll(this._places);
      setState(() {
        this._containerChild = _buildPlacesStream();
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
                  location: document['location'],
                );
              },
            ).toList();
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

  void _sortPlaces() {
    if (_sortByDistance &&
        CurrentUserLocation().hasPermission != null &&
        CurrentUserLocation().hasPermission)
      sortPlacesByDistance();
    else
      sortPlacesByName();
  }
}
