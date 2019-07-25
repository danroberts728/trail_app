import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class TrailPlace {
  final String name;
  final String address;
  final String city;
  final String state;
  final String zip;
  final String featuredImgUrl;
  final String logoUrl;
  final List<String> categories;
  final GeoPoint location;
  String distance;

  TrailPlace(
      {@required this.name,
      @required this.address,
      @required this.city,
      @required this.state,
      @required this.zip,
      @required this.featuredImgUrl,
      @required this.logoUrl,
      @required this.categories,
      @required this.location});

  static const _R = 3958.756; // in miles
  static double calculateDistance(GeoPoint point1, GeoPoint point2) {
    double dLat = _toRadians(point2.latitude - point1.latitude);
    double dLon = _toRadians(point2.longitude - point1.longitude);
    double lat1 = _toRadians(point1.latitude);
    double lat2 = _toRadians(point2.latitude);

    double a =
        pow(sin(dLat / 2), 2) + pow(sin(dLon / 2), 2) * cos(lat1) * cos(lat2);
    double c = 2 * asin(sqrt(a));
    return _R * c;
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
