import 'dart:math';

import 'dart:ui';

import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TrailEvent {
  final String eventName;
  final String eventSubTitle;
  final String eventImageUrl;
  final String learnMoreLink;
  final DateTime eventStart;
  final bool isEventAllDay;
  final DateTime eventEnd;
  final bool noEndTime;
  final List<String> regionCategory;
  final List<String> eventCategory;
  final Color eventColor;
  final String eventLocationName;
  final String eventLocationAddress;
  final Point eventLocationCoord;
  final TrailPlace eventTrailPlace;
  final bool isFeatured;
  final String eventDetails;

  TrailEvent({
    @required this.eventName,
    this.eventSubTitle,
    this.eventImageUrl,
    this.learnMoreLink,
    @required this.eventStart,
    this.isEventAllDay,
    this.eventEnd,
    this.noEndTime,
    this.regionCategory,
    this.eventCategory,
    this.eventColor,
    this.eventLocationName,
    this.eventLocationAddress,
    this.eventLocationCoord,
    this.eventTrailPlace,
    this.isFeatured,
    this.eventDetails,
  });

  static TrailEvent buildFromFirebase(DocumentSnapshot d) {
    try {
      return TrailEvent(
        eventName: d['event_name'] ?? "Unnamed Event",
        eventSubTitle: d['event_sub_title'] ?? "",
        eventStart: d['event_start'].toDate(),
        eventCategory: d['event_category'] != null
            ? List<String>.from(d['event_category'])
            : List<String>(),
        eventColor:
            d['event_color'] != null ? _fromHex(d['event_color']) : Colors.black,
        eventEnd: d['event_end'] != null ? d['event_end'].toDate() : null,
        eventImageUrl: d['event_image_url'],
        eventLocationAddress: d['event_location_address'],
        eventLocationCoord: d['event_location_coord'] != null
            ? Point(d['event_location_coord'].latitude,
                d['event_location_coord'].longitude)
            : null,
        eventLocationName: d['event_location_name'],
        eventTrailPlace: d['event_trail_place'],
        isEventAllDay: d['is_all_day'] ?? false,
        isFeatured: d['is_featured'] ?? false,
        learnMoreLink: d['learn_more_link'],
        noEndTime: d['no_end_time'] ?? d['event_end'] == null,
        eventDetails: d['event_details'] ?? '',
        regionCategory: d['region_category'] != null
            ? List<String>.from(d['region_category'])
            : List<String>(),
      );
    } catch (e) {
      throw e;
    }
  }

  static Color _fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
