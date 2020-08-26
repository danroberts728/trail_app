import 'dart:async';

import 'package:alabama_beer_trail/data/trail_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'bloc.dart';

class SingleTrailEventBloc extends Bloc {
  SingleTrailEventBloc(String eventId) {
    FirebaseFirestore.instance.collection('events/').doc(eventId)
      .snapshots()
      .listen(_onDataUpdate);
  }

  TrailEvent trailEvent;
  final _trailEventController = StreamController<TrailEvent>();
  Stream<TrailEvent> get trailEventStream =>
      _trailEventController.stream;

  void _onDataUpdate(DocumentSnapshot querySnapshot) {
    try {
      TrailEvent newTrailEvent = TrailEvent.buildFromFirebaseDocument(querySnapshot);
      trailEvent = newTrailEvent;
      _trailEventController.sink.add(trailEvent);
    } catch (error) {
      print(error);
    }
  }

  @override
  void dispose() {
    _trailEventController.close();
  }
}
