// Copyright (c) 2020, Fermented Software.
import 'dart:math';

import 'package:alabama_beer_trail/model/beer.dart';
import 'package:alabama_beer_trail/model/on_tap_beer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Data reprsentation of a Trail Place
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
  final List<Map<String, dynamic>> hoursDetail;
  final String description;
  final Map<String, String> emails;
  final Map<String, String> phones;
  final bool isMember;
  final int locationTaxonomy;
  List<Beer> allBeers = <Beer>[];
  List<OnTapBeer> onTap = <OnTapBeer>[];

  /// Default constructor
  TrailPlace(
      {@required this.id,
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
      @required this.hoursDetail,
      @required this.description,
      @required this.emails,
      @required this.phones,
      @required this.isMember,
      @required this.locationTaxonomy});

  /// Creates a beer from a document snapshot from firebase
  static TrailPlace createFromFirebaseDocument(DocumentSnapshot snapshot) {
    try {
      var d = snapshot.data();
      return TrailPlace(
          id: snapshot.id,
          name: d['name'],
          address: d['address'],
          city: d['city'],
          state: d['state'],
          zip: d['zip'],
          logoUrl: d['logo_img'],
          featuredImgUrl: d['featured_img'],
          galleryUrls: d['gallery_urls'] == null
              ? <String>[]
              : List<String>.from(d['gallery_urls']),
          categories: d['categories'] == null
              ? <String>[]
              : List<String>.from(d['categories']),
          connections: d['connections'] == null
              ? Map<String, String>()
              : Map<String, String>.from(d['connections']),
          hours: d['hours'] == null
              ? Map<String, String>()
              : Map<String, String>.from(d['hours']),
          hoursDetail: d['hours_detail'] == null
              ? <Map<String, dynamic>>[]
              : List<Map<String, dynamic>>.from(d['hours_detail']),
          location: Point(d['location'].latitude, d['location'].longitude),
          description: d['description'],
          emails: d['emails'] == null
              ? Map<String, String>()
              : Map<String, String>.from(d['emails']),
          phones: d['phones'] == null
              ? Map<String, String>()
              : Map<String, String>.from(d['phones']),
          isMember: d['is_member'] == null ? false : d['is_member'],
          locationTaxonomy: d['location_tax'] == null ? 0 : d['location_tax']);
    } catch (e) {
      throw e;
    }
  }

  /// Creates a beer from a query document snapshot from firebase
  static TrailPlace createFromFirebase(QueryDocumentSnapshot snapshot) {
    try {
      var d = snapshot.data();
      return TrailPlace(
          id: snapshot.id,
          name: d['name'],
          address: d['address'],
          city: d['city'],
          state: d['state'],
          zip: d['zip'],
          logoUrl: d['logo_img'],
          featuredImgUrl: d['featured_img'],
          galleryUrls: d['gallery_urls'] == null
              ? <String>[]
              : List<String>.from(d['gallery_urls']),
          categories: d['categories'] == null
              ? <String>[]
              : List<String>.from(d['categories']),
          connections: d['connections'] == null
              ? Map<String, String>()
              : Map<String, String>.from(d['connections']),
          hours: d['hours'] == null
              ? Map<String, String>()
              : Map<String, String>.from(d['hours']),
          hoursDetail: d['hours_detail'] == null
              ? <Map<String, dynamic>>[]
              : List<Map<String, dynamic>>.from(d['hours_detail']),
          location: Point(d['location'].latitude, d['location'].longitude),
          description: d['description'],
          emails: d['emails'] == null
              ? Map<String, String>()
              : Map<String, String>.from(d['emails']),
          phones: d['phones'] == null
              ? Map<String, String>()
              : Map<String, String>.from(d['phones']),
          isMember: d['is_member'] == null ? false : d['is_member'],
          locationTaxonomy: d['location_tax'] == null ? 0 : d['location_tax']);
    } catch (e) {
      throw e;
    }
  }
}
