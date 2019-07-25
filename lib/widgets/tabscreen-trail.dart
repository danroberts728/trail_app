import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/trailplace.dart';
import 'traillistitem.dart';
import '../util/currentUserLocation.dart';

class TrailList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TrailList();
}

class _TrailList extends State<TrailList>
    with AutomaticKeepAliveClientMixin<TrailList> {
  bool _sortByDistance = true;
  Widget _screen = Center(child: CircularProgressIndicator());

  _TrailList() {
    StreamSubscription subscription;
    subscription =
        CurrentUserLocation().streamBroadcast.stream.listen((Point p) {
      onLocationUpdate(p);
      subscription.cancel();
    });
  }

  void onLocationUpdate(Point p) {
    this._places.forEach((place) {
      double d = TrailPlace.calculateDistance(GeoPoint(p.latitude, p.longitude),
          GeoPoint(place.location.latitude, place.location.longitude));
      place.distance = TrailPlace.toFriendlyDistanceString(d);
    });
    setState(() {
      this._screen = buildPlacesStream();
    });
  }

  List<TrailPlace> _places = List<TrailPlace>();

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
      child: _screen,
    );
  }

  Future<void> screenRefresh() {
    return Future<void>.sync(() {
      onLocationUpdate( Point(CurrentUserLocation().latitude, CurrentUserLocation().longitude) );
      print("Refreshed");
    });   
  }

  StreamBuilder<QuerySnapshot> buildPlacesStream() {
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
              if (_sortByDistance &&
                  CurrentUserLocation().hasPermission != null &&
                  CurrentUserLocation().hasPermission)
                sortPlacesByDistance();
              else
                sortPlacesByName();

              return RefreshIndicator(
                  onRefresh: this.screenRefresh,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: this._places.length,
                    itemBuilder: (BuildContext context, int index) {
                      List<TrailPlace> p = this._places;
                      return new TrailListItem(place: p[index]);
                    },
                  ));
          }
        });
  }
}
