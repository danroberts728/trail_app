// Copyright (c) 2020, Fermented Software.
import 'package:cloud_firestore/cloud_firestore.dart';

/// Representation of an on_tap entry in the cloud database
class OnTapBeer {
  final String abv;
  final int ibu;
  final String logoUrl;
  final String manufacturer;
  final String name;
  final String style;

  OnTapBeer(
      {this.abv,
      this.ibu,
      this.logoUrl,
      this.manufacturer,
      this.name,
      this.style});

  /// Creates an OnTapBeer from a query document snapshot from firebase
  /// 
  /// Returns null if the beer does not find a name or untappd ID
  static OnTapBeer createFromFirebase(QueryDocumentSnapshot snapshot) {
    try {
      var d = snapshot.data();
      var beer = OnTapBeer(
        abv: d['abv'] == null ? "N/A" : d['abv'],
        ibu: d['ibu'] == null ? 0 : d['ibu'],
        logoUrl: d['logo_url'] == null ?  "" : d['logo_url'],
        manufacturer: d['manufacturer_name'] == null ? "" : d['manufacturer_name'],
        name: d['name'] == null ? "" : d['name'],
        style: d['style'] == null ? "" : d['style'],
      );
      if(beer.name == "") {
        return null;
      } else {
        return beer;
      }
    } catch(err) {
      return null;
    }
  }
}
