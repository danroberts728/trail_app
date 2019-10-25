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
  final List<String> galleryUrls;
  final Map<String, String> connections;
  final Map<String, String> hours;
  final String description;
  final Map<String, String> emails;
  final Map<String, String> phones;

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
      @required this.galleryUrls,
      @required this.categories,
      @required this.location,
      @required this.connections,
      @required this.hours,
      @required this.description, 
      @required this.emails, 
      @required this.phones,
      });
}
