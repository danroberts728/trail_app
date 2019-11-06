import 'dart:async';

import 'package:alabama_beer_trail/data/trail_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'bloc.dart';

class MonthlyEventsBloc extends Bloc {
  MonthlyEventsBloc(DateTime month) {
    Timestamp startOfMonth = Timestamp.fromDate(DateTime(month.year, month.month, 1, 0, 0, 0, 0, 0));
    DateTime startOfMonthDate = startOfMonth.toDate();
    Timestamp endOfMonth = Timestamp.fromDate( DateTime(startOfMonthDate.year, startOfMonthDate.month + 1) );

    DateTime now = DateTime.now();

    // Starting date is either the beginning of today or the beginning of the month, whichever is later.
    // This prevents old events from showing up but still lists events tha happened today
    Timestamp startTimestamp = Timestamp.now().millisecondsSinceEpoch > startOfMonth.millisecondsSinceEpoch
      ? Timestamp.fromDate(DateTime(now.year, now.month, now.day, 0, 0, 0, 0, 0))
      : startOfMonth;

    Firestore.instance.collection('events/')
      .where('event_start', isGreaterThanOrEqualTo: startTimestamp)
      .orderBy('event_start')
      .endBefore([endOfMonth])
      .snapshots().listen(_onDataUpdate);
  }

  List<TrailEvent> trailEvents = List<TrailEvent>();
  final _trailEventsController = StreamController<List<TrailEvent>>();
  Stream<List<TrailEvent>> get trailEventsStream => _trailEventsController.stream;


  void _onDataUpdate(QuerySnapshot querySnapshot) {
    var newDocs = querySnapshot.documents;

    List<TrailEvent> newTrailEvents = List<TrailEvent>();
    newDocs.forEach((d) {
      try {
        newTrailEvents.add(
          TrailEvent.buildFromFirebase(d)
        );
      } catch (e) {
        print(e);
      }
    });
    this.trailEvents = newTrailEvents;
    this._trailEventsController.sink.add(this.trailEvents);
  }

  @override
  void dispose() {
    _trailEventsController.close();
  }
}