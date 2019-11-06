import 'dart:async';

import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'bloc.dart';

class TrailPlacesBloc extends Bloc {
  TrailPlacesBloc() {
    Firestore.instance.collection('places/').snapshots().listen(_onDataUpdate);
  }

  List<TrailPlace> trailPlaces = List<TrailPlace>();
  final _trailPlacesController = StreamController<List<TrailPlace>>();
  Stream<List<TrailPlace>> get trailPlaceStream =>
      _trailPlacesController.stream;

  void _onDataUpdate(QuerySnapshot querySnapshot) {
    var newDocs = querySnapshot.documents;

    List<TrailPlace> newTrailPlaces = List<TrailPlace>();
    newDocs.forEach((d) {
      try {
        newTrailPlaces.add(
          TrailPlace.createFromFirebase(d)
        );
      } catch (e) {
        print(e);
      }
    });
    this.trailPlaces = newTrailPlaces;
    this._trailPlacesController.sink.add(this.trailPlaces);
  }

  @override
  void dispose() {
    _trailPlacesController.close();
  }
}
