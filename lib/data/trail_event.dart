import 'dart:math';

import 'dart:ui';

import 'package:alabama_beer_trail/data/trail_place.dart';
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

  TrailEvent(
      {@required this.eventName,
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
      this.isFeatured, });
}
