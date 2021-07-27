// Copyright (c) 2021, Fermented Software.

/// Database representation of a trail event
class TrailEventModel {
  final String id;
  final String name;
  final String details;
  final String color;
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

  TrailEventModel(
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
}
