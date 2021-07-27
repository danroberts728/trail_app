// Copyright (c) 2021, Fermented Software.
import 'dart:math';

import 'package:trail_database/domain/beer.dart';
import 'package:trail_database/domain/on_tap_beer.dart';
import 'package:trail_database/model/trail_place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trail_database/trail_database.dart';

/// Logical representation of a place
class TrailPlace {
  TrailDatabase _db;
  TrailPlaceModel _model;

  String get id => _model.id;
  String get name => _model.name;
  String get address => _model.address;
  String get city => _model.city;
  String get state => _model.state;
  String get zip => _model.zip;
  String get logoUrl => _model.logoUrl;
  String get featuredImgUrl => _model.featuredImgUrl;
  List<String> get galleryUrls => _model.galleryUrls;
  List<String> get categories => _model.categories;
  Map<String, String> get connections => _model.connections;
  Map<String, String> get hours => _model.hours;
  List<Map<String, dynamic>> get hoursDetail => _model.hoursDetail;
  Point get location => _model.location;
  String get description => _model.description;
  Map<String, String> get emails => _model.emails;
  Map<String, String> get phones => _model.phones;
  bool get isMember => _model.isMember;
  bool get published => _model.published;
  int get locationTaxonomy => _model.locationTaxonomy;

  set name(String value) {
    _db.updatePlace(id, {
      'name': value
    });
  }

  set categories(List<String> value) {
    _db.updatePlace(id, {
      'categories': value
    });
  }

  List<Beer> allBeers = <Beer>[];
  List<OnTapBeer> onTap = <OnTapBeer>[];

  TrailPlace({TrailPlaceModel model}) : assert(model != null) {
    _model = model;
  }

  static TrailPlace create({
    String id,
    String name,
    String address,
    String city,
    String state,
    String zip,
    String logoUrl,
    String featuredImgUrl,
    List<String> galleryUrls,
    List<String> categories,
    Map<String, String> connections,
    Map<String, String> hours,
    List<Map<String, dynamic>> hoursDetail,
    Point location,
    String description,
    Map<String, String> emails,
    Map<String, String> phones,
    bool isMember,
    bool published,
    int locationTaxonomy,
  }) {
    return TrailPlace(
        model: TrailPlaceModel(
      id: id,
      name: name,
      address: address,
      city: city,
      state: state,
      zip: zip,
      logoUrl: logoUrl,
      featuredImgUrl: featuredImgUrl,
      galleryUrls: galleryUrls,
      categories: categories,
      connections: connections,
      hours: hours,
      hoursDetail: hoursDetail,
      location: location,
      description: description,
      emails: emails,
      phones: phones,
      isMember: isMember,
      published: published,
      locationTaxonomy: locationTaxonomy,
    ));
  }

  static TrailPlace fromFirebase(DocumentSnapshot snapshot) {
    try {
      var d = snapshot.data() as Map<String, dynamic>;
      var trailPlaceModel = TrailPlaceModel(
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
          published: d['published'] == null ? false : d['published'], 
          locationTaxonomy: d['location_tax'] == null ? 0 : d['location_tax']);
      return TrailPlace(model: trailPlaceModel);
    } catch (e) {
      throw e;
    }
  }

  /// Creates a beer from a query document snapshot from firebase
  static TrailPlace createFromFirebase(QueryDocumentSnapshot snapshot) {
    try {
      var d = snapshot.data() as Map<String, dynamic>;
      var trailPlaceModel = TrailPlaceModel(
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
          published: d['published'] == null ? false : d['published'], 
          locationTaxonomy: d['location_tax'] == null ? 0 : d['location_tax']);
      return TrailPlace(model: trailPlaceModel);
    } catch (e) {
      throw e;
    }
  }
}
