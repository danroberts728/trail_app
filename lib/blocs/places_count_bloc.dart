import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'bloc.dart';

class PlacesCountBloc extends Bloc {
  // TODO: Change to PlacesBloc and make it the only thing that accesses Firestore
  PlacesCountBloc() {
    Firestore.instance.collection('places/').snapshots().listen(_onDataUpdate);
  }

  int placesCount = 0;
  final _placesCountController = StreamController<int>();
  Stream<int> get placesCountStream  => _placesCountController.stream;  

  void _onDataUpdate(QuerySnapshot querySnapshot) {
    placesCount = querySnapshot.documents.length;
    _placesCountController.add(placesCount);
  }

  @override
  void dispose() {
    _placesCountController.close();
  }

}