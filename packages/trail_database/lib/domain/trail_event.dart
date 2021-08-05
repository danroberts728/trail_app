// Copyright (c) 2021, Fermented Software.
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trail_database/model/trail_event.dart';

/// Logical representation of an event
class TrailEvent {
  TrailEventModel _model;

  String get id => _model.id;
  String get name => _model.name;
  String get details => _model.details;
  Color get color => _fromHex(_model.color);
  bool get featured => _model.featured;
  String get imageUrl => _model.imageUrl;
  String get learnMoreLink => _model.learnMoreLink;
  String get status => _model.status;
  int get locationTaxonomy => _model.locationTaxonomy;
  String get locationName => _model.locationName;
  String get locationAddress => _model.locationAddress;
  String get locationCity => _model.locationCity;
  String get locationState => _model.locationState;
  double get locationLat => _model.locationLat;
  double get locationLon => _model.locationLon;
  DateTime get start => _model.start;
  DateTime get end => _model.end;
  bool get hideEndTime => _model.hideEndTime;
  String get eventTimeZone => _model.eventTimeZone;
  bool get allDayEvent => _model.allDayEvent;

  TrailEvent({
    TrailEventModel model,
  }) : assert(model != null) {
    _model = model;
  }

  /// Creates a TrailEvent from manual data
  static TrailEvent create({
    String id,
    String name,
    String details,
    String color,
    bool featured,
    String imageUrl,
    String learnMoreLink,
    String status,
    int locationTaxonomy,
    String locationName,
    String locationAddress,
    String locationCity,
    String locationState,
    double locationLat,
    double locationLon,
    DateTime start,
    DateTime end,
    bool hideEndTime,
    String eventTimeZone,
    bool allDayEvent,
  }) {
    return TrailEvent(
        model: TrailEventModel(
      id: id,
      name: name,
      details: details,
      color: color,
      featured: featured,
      imageUrl: imageUrl,
      learnMoreLink: learnMoreLink,
      status: status,
      locationTaxonomy: locationTaxonomy,
      locationName: locationName,
      locationAddress: locationAddress,
      locationCity: locationCity,
      locationState: locationState,
      locationLat: locationLat,
      locationLon: locationLon,
      start: start,
      end: end,
      hideEndTime: hideEndTime,
      eventTimeZone: eventTimeZone,
      allDayEvent: allDayEvent,
    ));
  }

  /// Build a TrailEvent from a [snapshot]
  static TrailEvent fromFirebase(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    var id = snapshot.id;
    try {
      var trailEventModel = TrailEventModel(
        id: id,
        name: data['name'] ?? '<Unnamed>',
        details: data['details'] ?? '',
        color: data['color'] ?? "00000000",
        featured: data['featured'] != null ? data['featured'] == 'yes' : false,
        imageUrl: data['image_url'] != null ? data['image_url'] : null,
        learnMoreLink:
            data['learnmore_link'] != null ? data['learnmore_link'] : '',
        status: data['status'] != null ? data['status'] : '',
        locationTaxonomy:
            data['location_tax'] != null ? data['location_tax'] : 0,
        locationName:
            data['location_name'] != null 
              // Fix for certain HTML-based event management systems that export with HTML Codes
              ? (data['location_name'] as String).replaceAll('&amp;', '&') 
              : '',
        locationAddress:
            data['location_address'] != null ? data['location_address'] : '',
        locationCity:
            data['location_city'] != null ? data['location_city'] : '',
        locationState:
            data['location_state'] != null ? data['location_state'] : '',
        locationLat: data['location_lat'] != null
            ? double.tryParse(data['location_lat'])
            : null,
        locationLon: data['location_lon'] != null
            ? double.tryParse(data['location_lon'])
            : null,
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
        hideEndTime: data['hide_endtime'] != null
            ? data['hide_endtime'] == 'yes'
            : false,
        allDayEvent: data['all_day_event'] != null
            ? data['all_day_event'] == "yes"
            : false,
      );
      // Return null if lat/lon or start time is not set correctly
      if (trailEventModel.locationLat == null ||
          trailEventModel.locationLon == null ||
          trailEventModel.start == DateTime(2000)) {
        return null;
      }
      return TrailEvent(model: trailEventModel);
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
}
