import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
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
    @required this.description,
    @required this.emails,
    @required this.phones,
  });

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
        location: Point(d['location'].latitude, d['location'].longitude),
        description: d['description'],
        emails: d['emails'] == null
            ? Map<String, String>()
            : Map<String, String>.from(d['emails']),
        phones: d['phones'] == null
            ? Map<String, String>()
            : Map<String, String>.from(d['phones']),
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
        location: Point(d['location'].latitude, d['location'].longitude),
        description: d['description'],
        emails: d['emails'] == null
            ? Map<String, String>()
            : Map<String, String>.from(d['emails']),
        phones: d['phones'] == null
            ? Map<String, String>()
            : Map<String, String>.from(d['phones']),
      );
    } catch (e) {
      throw e;
    }
  }
}
