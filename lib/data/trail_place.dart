import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
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
  final List<Map<String, dynamic>> hoursDetail;
  final String description;
  final Map<String, String> emails;
  final Map<String, String> phones;
  final bool isMember;

  TrailPlace({
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
    @required this.hoursDetail,
    @required this.description,
    @required this.emails,
    @required this.phones,
    @required this.isMember
  });

  bool isEqual(TrailPlace other) {

    return 
      address == other.address &&
      categories.length == other.categories.length &&
      listEquals(categories, other.categories) &&
      city == other.city &&
      mapEquals(connections, other.connections) &&
      description == other.description &&
      mapEquals(emails, other.emails) &&
      featuredImgUrl == other.featuredImgUrl &&
      listEquals(galleryUrls, other.galleryUrls) &&
      mapEquals(hours, other.hours) &&
      location.x == other.location.x &&
      location.y == other.location.y &&
      logoUrl == other.logoUrl &&
      name == other.name &&
      mapEquals(phones, other.phones) &&
      state == other.state &&
      zip == other.zip;
  }

  static TrailPlace createBlank() {
    return TrailPlace(
      address: '',
      categories: List<String>(),
      city: '',
      connections: Map<String, String>(),
      description: '',
      emails: Map<String, String>(),
      featuredImgUrl: '',
      galleryUrls: List<String>(),
      hours: Map<String, String>(),
      hoursDetail: List<Map<String, dynamic>>(),
      id: '',
      location: Point(0, 0),
      isMember: false,
      logoUrl: '',
      name: '',
      phones: Map<String, String>(),
      state: '',
      zip: ''
    );
  }

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
            ? List<String>()
            : List<String>.from(d['gallery_urls']),
        categories: d['categories'] == null
            ? List<String>()
            : List<String>.from(d['categories']),
        connections: d['connections'] == null
            ? Map<String, String>()
            : Map<String, String>.from(d['connections']),
        hours: d['hours'] == null
            ? Map<String, String>()
            : Map<String, String>.from(d['hours']),
        hoursDetail: d['hours_detail'] == null
            ? List<Map<String, dynamic>>()
            : List<Map<String, dynamic>>.from(d['hours_detail']),
        location: Point(d['location'].latitude, d['location'].longitude),
        description: d['description'],
        emails: d['emails'] == null
            ? Map<String, String>()
            : Map<String, String>.from(d['emails']),
        phones: d['phones'] == null
            ? Map<String, String>()
            : Map<String, String>.from(d['phones']),
        isMember: d['is_member'] == null
            ? false
            : d['is_member']
      );
    } catch (e) {
      throw e;
    }
  }

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
            ? List<String>()
            : List<String>.from(d['gallery_urls']),
        categories: d['categories'] == null
            ? List<String>()
            : List<String>.from(d['categories']),
        connections: d['connections'] == null
            ? Map<String, String>()
            : Map<String, String>.from(d['connections']),
        hours: d['hours'] == null
            ? Map<String, String>()
            : Map<String, String>.from(d['hours']),
        hoursDetail: d['hours_detail'] == null
            ? List<Map<String, dynamic>>()
            : List<Map<String, dynamic>>.from(d['hours_detail']),
        location: Point(d['location'].latitude, d['location'].longitude),
        description: d['description'],
        emails: d['emails'] == null
            ? Map<String, String>()
            : Map<String, String>.from(d['emails']),
        phones: d['phones'] == null
            ? Map<String, String>()
            : Map<String, String>.from(d['phones']),
        isMember: d['is_member'] == null
            ? false
            : d['is_member']
      );
    } catch (e) {
      throw e;
    }
  }
}
