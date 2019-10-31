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
    newDocs.forEach((d) => newTrailEvents.add(TrailEvent(
      eventName: d['event_name'] ?? "Unnamed Event",
      eventSubTitle: d['event_sub_title'] ?? "",
      eventStart: d['event_start'].toDate(),
      eventCategory: d['event_category'] != null ? List<String>.from(d['event_category']) : List<String>(),
      eventColor: d['event_color'] != null ? fromHex(d['event_color']) : Colors.black,
      eventEnd: d['event_end'] != null ? d['event_end'].toDate() : null,
      eventImageUrl: d['event_image_url'],
      eventLocationAddress: d['event_location_address'],
      eventLocationCoord: d['event_location_coord'] != null
        ? Point(d['event_location_coord'].latitude, d['event_location_coord'].longitude)
        : null,
      eventLocationName: d['event_location_name'],
      eventTrailPlace: d['event_trail_place'],
      isEventAllDay: d['is_all_day'] ?? false,
      isFeatured: d['is_featured'] ?? false,
      learnMoreLink: d['learn_more_link'],
      noEndTime: d['no_end_time'] ?? d['event_end'] == null,
      eventDetails: d['event_details'] ?? '',
      regionCategory: d['region_category'] != null ? List<String>.from(d['region_category']) : List<String>(),
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