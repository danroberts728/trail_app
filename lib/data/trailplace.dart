import 'dart:math';

import 'package:flutter/material.dart';

class TrailPlace {
  final String id;
  final String name;
  final String address;
  final String city;
  final String state;
  final String zip;
  final String featuredImgUrl;
  final String logoUrl;
  final List<String> categories;
  final Point location;
  double lastClaculatedDistance = 0.00;

  TrailPlace(
      {
      @required this.id,
      @required this.name,
      @required this.address,
      @required this.city,
      @required this.state,
      @required this.zip,
      @required this.featuredImgUrl,
      @required this.logoUrl,
      @required this.categories,
      @required this.location});

  static const _R = 3958.756; // in miles
  
  double calculateDistance(Point point) {
    if(point == null || this.location == null) {
      return null;
    }
    double dLat = _toRadians(point.x - this.location.x);
    double dLon = _toRadians(point.y - this.location.y);
    double lat1 = _toRadians(this.location.x);
    double lat2 = _toRadians(point.x);

    double a =
        pow(sin(dLat / 2), 2) + pow(sin(dLon / 2), 2) * cos(lat1) * cos(lat2);
    double c = 2 * asin(sqrt(a));
    this.lastClaculatedDistance = _R * c;
    return this.lastClaculatedDistance;
  }

  static double _toRadians(double degree) {
    return degree * pi / 180;
  }

  static String toFriendlyDistanceString(double d) {
    // Greater than 10, just round to nearest int
    if (d >= 10) return d.round().toString();
    // Greater than 1, round to nearest 0.1
    if (d >= 1)
      return d.toStringAsFixed(1);
    // Less than 1, round to nearest 0.01
    else
      return d.toStringAsFixed(2);
  }
}
