import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Data representation of a trail event
class TrailEvent {
  final String id;
  final String name;
  final String details;
  final Color color;
  final bool featured;
  final String imageUrl;
  final String learnMoreLink;
  final String status;

  final int locationTaxonomy;
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
      this.allDayEvent,
      this.locationTaxonomy});

  /// Build a TrailEvent from a [snapshot]
  static TrailEvent buildFromFirebaseDocument(DocumentSnapshot snapshot) {
    var data = snapshot.data();
    var id = snapshot.id;
    return _buildFromSnapshot(id, data);
  }

  /// Build a TrailEvent from a [snapshot]
  static TrailEvent buildFromFirebase(QueryDocumentSnapshot snapshot) {
    var data = snapshot.data();
    var id = snapshot.id;
    return _buildFromSnapshot(id, data);
  }

  /// Build a TrailEvent from a snapshot's [data] with [id]
  static TrailEvent _buildFromSnapshot(String id, Map<String, dynamic> data) {
    try {
      var trailEvent = TrailEvent(
        id: id,
        name: data['name'] ?? '<Unnamed>',
        details: data['details'] ?? '',
        color: data['color'] != null ? _fromHex(data['color']) : Colors.black,
        featured: data['featured'] != null ? data['featured'] == 'yes' : false,
        imageUrl: data['image_url'] != null ? data['image_url'] : null,
        learnMoreLink: data['learnmore_link'] != null ? data['learnmore_link'] : '',
        status: data['status'] != null ? data['status'] : '',
        locationTaxonomy: data['location_tax'] != null ? data['location_tax'] : 0,
        locationName: data['location_name'] != null ? data['location_name'] : '',
        locationAddress:
            data['location_address'] != null ? data['location_address'] : '',
        locationCity: data['location_city'] != null ? data['location_city'] : '',
        locationState: data['location_state'] != null ? data['location_state'] : '',
        locationLat: data['location_lat'] != null ? double.tryParse(data['location_lat']) : null,
        locationLon: data['location_lon'] != null ? double.tryParse(data['location_lon']) : null,
        start: data['start_timestamp_seconds'] != null
            ? Timestamp(data['start_timestamp_seconds'], 0)
                .toDate()
                .subtract(DateTime.now().timeZoneOffset)
            : DateTime(2000),
        end: data['end_timestamp_seconds'] != null
            ? Timestamp(data['end_timestamp_seconds'], 0)
                .toDate()
                .subtract(DateTime.now().timeZoneOffset)
            : null,
        hideEndTime:
            data['hide_endtime'] != null ? data['hide_endtime'] == 'yes' : false,
        allDayEvent:
            data['all_day_event'] != null ? data['all_day_event'] == "yes" : false,        
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

  /// Return an ARGB color from a RGB hex string
  static Color _fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Get an appropriate time string for this event given it's
  /// [start], [end] and whether [hideEndTime] is true
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
