// Copyright (c) 2020, Fermented Software.
import 'dart:math';

/// Database reprsentation of a Trail Place
class TrailPlaceModel {
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
  final bool published;
  final int locationTaxonomy;

  /// Default constructor
  TrailPlaceModel(
      {this.id,
      this.name,
      this.address,
      this.city,
      this.state,
      this.zip,
      this.featuredImgUrl,
      this.logoUrl,
      this.galleryUrls,
      this.categories,
      this.location,
      this.connections,
      this.hours,
      this.hoursDetail,
      this.description,
      this.emails,
      this.phones,
      this.isMember,
      this.published,
      this.locationTaxonomy});
}
