// Copyright (c) 2020, Fermented Software.
import 'dart:async';

import 'package:trail_database/domain/trail_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:beer_trail_app/blocs/bloc.dart';

/// The BLoC for SingleTrailEvent objects
class SingleTrailEventBloc extends Bloc {
  /// Default constructor
  SingleTrailEventBloc(String eventId) {
    FirebaseFirestore.instance.collection('events/').doc(eventId)
      .snapshots()
      .listen(_onDataUpdate);
  }

  /// The trail event
  TrailEvent trailEvent;

  /// Controller for this BLoC's stream
  final _trailEventController = StreamController<TrailEvent>();

  /// Stream for trail event updates
  Stream<TrailEvent> get trailEventStream =>
      _trailEventController.stream;

  /// Callback when trail is updated
  void _onDataUpdate(DocumentSnapshot querySnapshot) {
    try {
      TrailEvent newTrailEvent = TrailEvent.fromFirebase(querySnapshot);
      trailEvent = newTrailEvent;
      _trailEventController.sink.add(trailEvent);
    } catch (error) {
      print(error);
    }
  }

  /// Dipose object
  @override
  void dispose() {
    _trailEventController.close();
  }
}
