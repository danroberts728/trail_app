import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TrailEvent {
  final String name;
  final String details;
  final Color color;
  final bool featured;
  final String imageUrl;

  final String locationName;
  final String locationAddress;

  final DateTime start;
  final DateTime end;
  final String eventTimeZone;
  final bool allDayEvent;


  TrailEvent(
    {this.name, 
    this.details, 
    this.color, 
    this.featured, 
    this.imageUrl, 
    this.locationName, 
    this.locationAddress, 
    this.start, 
    this.end, 
    this.eventTimeZone, 
    this.allDayEvent}
    
  );
  static TrailEvent buildFromFirebase(DocumentSnapshot d) {
    try {
      return TrailEvent(
        name: d['name'] ?? '<Unnamed>',
        details: d['details'] ?? '',
        color: d['color'] != null
          ? _fromHex(d['color'])
          : Colors.black,
        featured: d['featured'] != null
          ? d['featured'] == 'yes'
          : false,
        imageUrl: d['image_url'] != null
          ? d['image_url']
          : null,
        locationName: d['location_name'] != null
          ? d['location_name']
          : '',
        locationAddress: d['location_addrss'] != null
          ? d['location_address']
          : '',
        start: d['start'] != null
          ? Timestamp(int.parse(d['start']), 0).toDate()
          : DateTime(2000),
        end: d['end'] != null
          ? Timestamp(int.parse(d['end']), 0).toDate()
          : null,
        allDayEvent: d['all_day_event'] != null
          ? d['all_day_event'] == "yes"
          : false,
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
