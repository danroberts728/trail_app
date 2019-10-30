import 'dart:async';
import 'dart:math';

import 'package:alabama_beer_trail/data/trail_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'bloc.dart';

class MonthlyEventsBloc extends Bloc {
  MonthlyEventsBloc(DateTime month) {
    Timestamp startOfMonth = Timestamp.fromDate(DateTime(month.year, month.month, 1, 0, 0, 0, 0, 0));
    DateTime startOfMonthDate = startOfMonth.toDate();
    Timestamp endOfMonth = Timestamp.fromDate( DateTime(startOfMonthDate.year, startOfMonthDate.month + 1) );

    Timestamp startTimestamp = Timestamp.now().millisecondsSinceEpoch > startOfMonth.millisecondsSinceEpoch
      ? Timestamp.now()
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
    newDocs.forEach((d) => newTrailEvents.add(TrailEvent(
      eventName: d['event_name'],
      eventSubTitle: d['event_sub_title'],
      eventStart: d['event_start'].toDate(),
      eventCategory: List<String>.from(d['event_category']),
      eventColor: fromHex(d['event_color']),
      eventEnd: d['event_end'].toDate(),
      eventImageUrl: d['event_image_url'],
      eventLocationAddress: d['event_location_address'],
      eventLocationCoord: Point(d['event_location_coord'].latitude, d['event_location_coord'].longitude),
      eventLocationName: d['event_location_name'],
      eventTrailPlace: d['event_trail_place'],
      isEventAllDay: d['is_all_day'],
      isFeatured: d['is_featured'],
      learnMoreLink: d['learn_more_link'],
      noEndTime: d['no_end_time'],
      regionCategory: List<String>.from(d['region_category']),
    )));
    this.trailEvents = newTrailEvents;
    this._trailEventsController.sink.add(this.trailEvents);
  }

  @override
  void dispose() {
    _trailEventsController.close();
  }

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

}