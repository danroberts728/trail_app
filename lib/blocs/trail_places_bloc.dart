import 'dart:async';
import 'dart:math';

import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'bloc.dart';

class TrailPlacesBloc extends Bloc {
  TrailPlacesBloc() {
    Firestore.instance.collection('places/').snapshots().listen(_onDataUpdate);
  }

  List<TrailPlace> trailPlaces = List<TrailPlace>();
  final _trailPlacesController = StreamController<List<TrailPlace>>();
  Stream<List<TrailPlace>> get trailPlaceStream => _trailPlacesController.stream;


  void _onDataUpdate(QuerySnapshot querySnapshot) {
    var newDocs = querySnapshot.documents;

    List<TrailPlace> newTrailPlaces = List<TrailPlace>();
    newDocs.forEach((d) => newTrailPlaces.add(TrailPlace(
      id: d.documentID,
      name: d['name'],
      address: d['address'],
      city: d['city'],
      state: d['state'],
      zip: d['zip'],
      logoUrl: d['logo_img'],
      featuredImgUrl: d['featured_img'],
      galleryUrls: d['gallery_urls'] == null ? List<String>() : List<String>.from(d['gallery_urls']),
      categories: d['categories'] == null ? List<String>() : List<String>.from(d['categories']),
      connections: d['connections'] == null ? Map<String, String>() : Map<String, String>.from(d['connections']),
      hours: d['hours'] == null ? Map<String, String>() : Map<String,String>.from(d['hours']),
      location: (d['location'] is GeoPoint) 
        ? Point(d['location'].latitude, d['location'].longitude)
        : Point(d['location']['_latitude'], d['location']['_longitude']),
      description: d['description'],
      emails: d['emails'] == null ? Map<String, String>() : Map<String, String>.from(d['emails']),
      phones: d['phones'] == null ? Map<String, String>() : Map<String, String>.from(d['phones']),
    )));
    this.trailPlaces = newTrailPlaces;
    this._trailPlacesController.sink.add(this.trailPlaces);
  }

  @override
  void dispose() {
    _trailPlacesController.close();
  }

}