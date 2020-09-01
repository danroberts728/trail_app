import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrailEvent {
  final String id;
  final String name;
  final String details;
  final Color color;
  final bool featured;
  final String imageUrl;
  final String learnMoreLink;
  final String status;

  final String locationName;
  final String locationAddress;
  final String locationCity;
  final String locationState;
  final double locationLat;
  final double locationLon;

  final DateTime start;
  final DateTime end;
  final bool hideEndTime;
  final String eventTimeZone;
  final bool allDayEvent;

  TrailEvent(
      {this.id,
      this.name,
      this.details,
      this.color,
      this.featured,
      this.imageUrl,
      this.learnMoreLink,
      this.status,
      this.locationName,
      this.locationAddress,
      this.locationCity,
      this.locationState,
      this.locationLat,
      this.locationLon,
      this.start,
      this.end,
      this.hideEndTime,
      this.eventTimeZone,
      this.allDayEvent});

  static TrailEvent buildFromFirebaseDocument(DocumentSnapshot snapshot) {
    try {
      var d = snapshot.data();
      var trailEvent = TrailEvent(
        id: snapshot.id,
        name: d['name'] ?? '<Unnamed>',
        details: d['details'] ?? '',
        color: d['color'] != null ? _fromHex(d['color']) : Colors.black,
        featured: d['featured'] != null ? d['featured'] == 'yes' : false,
        imageUrl: d['image_url'] != null ? d['image_url'] : null,
        learnMoreLink: d['learnmore_link'] != null ? d['learnmore_link'] : '',
        status: d['status'] != null ? d['status'] : '',
        locationName: d['location_name'] != null ? d['location_name'] : '',
        locationAddress:
            d['location_address'] != null ? d['location_address'] : '',
        locationCity: d['location_city'] != null ? d['location_city'] : '',
        locationState: d['location_state'] != null ? d['location_state'] : '',
        locationLat: d['location_lat'] != null ? double.tryParse(d['location_lat']) : null,
        locationLon: d['location_lon'] != null ? double.tryParse(d['location_lon']) : null,
        start: d['start_timestamp_seconds'] != null
            ? Timestamp(d['start_timestamp_seconds'], 0)
                .toDate()
                .subtract(DateTime.now().timeZoneOffset)
            : DateTime(2000),
        end: d['end_timestamp_seconds'] != null
            ? Timestamp(d['end_timestamp_seconds'], 0)
                .toDate()
                .subtract(DateTime.now().timeZoneOffset)
            : null,
        hideEndTime:
            d['hide_endtime'] != null ? d['hide_endtime'] == 'yes' : false,
        allDayEvent:
            d['all_day_event'] != null ? d['all_day_event'] == "yes" : false,
      );
      // Return null if lat/lon or start time is not set correctly
      if( trailEvent.locationLat == null || trailEvent.locationLon == null  
        || trailEvent.start == DateTime(2000)) {
        return null;
      }
      return trailEvent;
    } catch (e) {
      return null;
    }
  }

  static TrailEvent buildFromFirebase(QueryDocumentSnapshot snapshot) {
    try {
      var d = snapshot.data();
      var trailEvent = TrailEvent(
        id: snapshot.id,
        name: d['name'] ?? '<Unnamed>',
        details: d['details'] ?? '',
        color: d['color'] != null ? _fromHex(d['color']) : Colors.black,
        featured: d['featured'] != null ? d['featured'] == 'yes' : false,
        imageUrl: d['image_url'] != null ? d['image_url'] : null,
        learnMoreLink: d['learnmore_link'] != null ? d['learnmore_link'] : '',
        status: d['status'] != null ? d['status'] : '',
        locationName: d['location_name'] != null ? d['location_name'] : '',
        locationAddress:
            d['location_address'] != null ? d['location_address'] : '',
        locationCity: d['location_city'] != null ? d['location_city'] : '',
        locationState: d['location_state'] != null ? d['location_state'] : '',
        locationLat: d['location_lat'] != null ? double.tryParse(d['location_lat']) : null,
        locationLon: d['location_lon'] != null ? double.tryParse(d['location_lon']) : null,
        start: d['start_timestamp_seconds'] != null
            ? Timestamp(d['start_timestamp_seconds'], 0)
                .toDate()
                .subtract(DateTime.now().timeZoneOffset)
            : DateTime(2000),
        end: d['end_timestamp_seconds'] != null
            ? Timestamp(d['end_timestamp_seconds'], 0)
                .toDate()
                .subtract(DateTime.now().timeZoneOffset)
            : null,
        hideEndTime:
            d['hide_endtime'] != null ? d['hide_endtime'] == 'yes' : false,
        allDayEvent:
            d['all_day_event'] != null ? d['all_day_event'] == "yes" : false,
      );
      // Return null if lat/lon or start time is not set correctly
      if( trailEvent.locationLat == null || trailEvent.locationLon == null  
        || trailEvent.start == DateTime(2000)) {
        return null;
      }
      return trailEvent;
    } catch (e) {
      return null;
    }
  }

  static Color _fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String getTimeString() {
    var event = this;
    if (event.allDayEvent) {
      return " (All Day: " + DateFormat("EEEEE").format(event.start) + ") ";
    } else if (event.hideEndTime) {
      return DateFormat("h:mm a").format(event.start);
    } else {
      return DateFormat("h:mm a").format(event.start) +
          " - " +
          DateFormat("h:mm a").format(event.end);
    }
  }
}
