// Copyright (c) 2020, Fermented Software.
import 'dart:async';

import 'package:trail_database/domain/trail_place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:beer_trail_app/blocs/bloc.dart';

/// The BLoC for SingleTralPlace objects
class SingleTrailPlaceBloc extends Bloc {
  /// Default constructor
  SingleTrailPlaceBloc(String placeId) {
    FirebaseFirestore.instance.collection('places/').doc(placeId)
      .snapshots()
      .listen(_onDataUpdate);
  }

  /// The trail place
  TrailPlace trailPlace;

  /// Controller for this BLoC's stream
  final _trailPlaceController = StreamController<TrailPlace>();

  /// Stream for updates to the trail place
  Stream<TrailPlace> get trailPlaceStream =>
      _trailPlaceController.stream;

  /// Callback when trail place is updated
  void _onDataUpdate(DocumentSnapshot querySnapshot) {
    try {
      TrailPlace newTrailPlace = TrailPlace.fromFirebase(querySnapshot);
      trailPlace = newTrailPlace;
      _trailPlaceController.sink.add(trailPlace);
    } catch (error) {
      print(error);
    }
  }

  /// Dispose object
  @override
  void dispose() {
    _trailPlaceController.close();
  }
}
