import 'dart:async';

import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'bloc.dart';

class SingleTrailPlaceBloc extends Bloc {
  SingleTrailPlaceBloc(String placeId) {
    FirebaseFirestore.instance.collection('places/').doc(placeId)
      .snapshots()
      .listen(_onDataUpdate);
  }

  TrailPlace trailPlace;
  final _trailPlaceController = StreamController<TrailPlace>();
  Stream<TrailPlace> get trailPlaceStream =>
      _trailPlaceController.stream;

  void _onDataUpdate(DocumentSnapshot querySnapshot) {
    try {
      TrailPlace newTrailPlace = TrailPlace.createFromFirebaseDocument(querySnapshot);
      trailPlace = newTrailPlace;
      _trailPlaceController.sink.add(trailPlace);
    } catch (error) {
      print(error);
    }
  }

  @override
  void dispose() {
    _trailPlaceController.close();
  }
}
