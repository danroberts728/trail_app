// Copyright (c) 2020, Fermented Software.
import 'package:cloud_firestore/cloud_firestore.dart';

/// Data representation of a beer
class Beer {
  final double abv;
  final String description;
  final int ibu;
  final String labelUrl;
  final String name;
  final String style;
  final bool isInProduction;
  final int untappdId;
  final int untappdRatingCount;
  final double untappdRatingScore;

  /// Default constructor
  Beer(
      {this.abv,
      this.description,
      this.ibu,
      this.labelUrl,
      this.name,
      this.style,
      this.isInProduction,
      this.untappdId,
      this.untappdRatingCount,
      this.untappdRatingScore});

  /// Creates a beer from a query document snapshot from firebase
  /// 
  /// Returns null if the beer does not find a name or untappd ID
  static Beer createFromFirebase(QueryDocumentSnapshot snapshot) {
    try {
      var d = snapshot.data();
      var beer = Beer(
        abv: d['beer_abv'] + 0.0 ?? 0.0,
        description: d['be er_description'] ?? "",
        ibu: d['beer_ibu'] ?? 0,
        labelUrl: d['beer_label'] ?? "",
        name: d['beer_name'] ?? "",
        style: d['beer_style'] ?? "",
        isInProduction: d['is_in_production'] == 1,
        untappdId: d['untappdId'] ?? 0,
        untappdRatingCount: d['untappd_rating_count'] ?? 0,
        untappdRatingScore: d['untappd_rating_score'] + .0 ?? 0,
      );
      if(beer.name == "" || beer.untappdId == 0) {
        return null;
      } else {
        return beer;
      }
    } catch(err) {
      return null;
    }
  }
}
