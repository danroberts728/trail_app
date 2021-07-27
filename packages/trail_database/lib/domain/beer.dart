// Copyright (c) 2021, Fermented Software.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trail_database/model/beer.dart';

/// Logical representation of a beer
class Beer {
  BeerModel _model;
  double get abv => _model.abv;
  String get description => _model.description;
  int get ibu => _model.ibu;
  String get labelUrl => _model.labelUrl;
  String get name => _model.name;
  String get style => _model.style;
  bool get isInproduction => _model.isInProduction;
  int get untappdId => _model.untappdId;
  int get untappdRatingCount => _model.untappdRatingCount;
  double get untappdRatingScore => _model.untappdRatingScore;

  Beer({BeerModel model}) : assert(model != null) {
    _model = model;
  }

  /// Creates a beer from manual data
  static Beer create(
      {double abv,
      String description,
      int ibu,
      String labelUrl,
      String name,
      String style,
      bool isInProduction,
      int untappdId,
      int untappdRatingCount,
      double untappdRatingScore}) {
    var beerModel = BeerModel(
        abv: abv,
        description: description,
        ibu: ibu,
        labelUrl: labelUrl,
        name: name,
        style: style,
        isInProduction: isInProduction,
        untappdId: untappdId,
        untappdRatingCount: untappdRatingCount,
        untappdRatingScore: untappdRatingScore);
    return Beer(model: beerModel);
  }

  /// Creates a beer from a query document snapshot from firebase
  ///
  /// Returns null if the beer does not find a name or untappd ID
  static Beer fromFirebase(QueryDocumentSnapshot snapshot) {
    try {
      var d = snapshot.data() as Map<String, dynamic>;
      var beerModel = BeerModel(
        abv: d['beer_abv'] + 0.0 ?? 0.0,
        description: d['beer_description'] ?? "",
        ibu: d['beer_ibu'] ?? 0,
        labelUrl: d['beer_label'] ?? "",
        name: d['beer_name'] ?? "",
        style: d['beer_style'] ?? "",
        isInProduction: d['is_in_production'] == 1,
        untappdId: d['untappdId'] ?? 0,
        untappdRatingCount: d['untappd_rating_count'] ?? 0,
        untappdRatingScore: d['untappd_rating_score'] + .0 ?? 0,
      );
      if (beerModel.name == "" || beerModel.untappdId == 0) {
        return null;
      } else {
        return Beer(model: beerModel);
      }
    } catch (err) {
      return null;
    }
  }
}
