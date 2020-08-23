import 'dart:async';

import 'package:alabama_beer_trail/data/trail_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'bloc.dart';

class EventsBloc extends Bloc {
  EventsBloc() {
    _restartSubscription();
  }

  void _restartSubscription() {
    if(_subscription != null) {
      _subscription.cancel();
    }
    Timestamp now = Timestamp.fromDate(DateTime.now());
    _subscription = Firestore.instance.collection('events/')
      .where('start_timestamp_seconds', isGreaterThanOrEqualTo: now.seconds)
      .orderBy('start_timestamp_seconds')
      .snapshots().listen(_onDataUpdate);
  }

  StreamSubscription _subscription;
  List<TrailEvent> trailEvents = List<TrailEvent>();
  final _trailEventsController = StreamController<List<TrailEvent>>();
  Stream<List<TrailEvent>> get trailEventsStream => _trailEventsController.stream;

  void _onDataUpdate(QuerySnapshot querySnapshot) {
    var newDocs = querySnapshot.documents;

    List<TrailEvent> newTrailEvents = List<TrailEvent>();
    newDocs.forEach((d) {
      TrailEvent e = TrailEvent.buildFromFirebase(d);      
      try {
        if(e != null) {
          newTrailEvents.add(e);
        }
      } catch (e) {
        print(e);
      }
    });
    this.trailEvents = newTrailEvents;
    this._trailEventsController.sink.add(this.trailEvents);
  }

  void forceUpdate() {
    _restartSubscription();
  }

  @override
  void dispose() {
    _trailEventsController.close();
  }
}