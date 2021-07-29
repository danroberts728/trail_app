// Copyright (c) 2021, Fermented Software.

import 'package:trail_database/domain/check_in.dart';
import 'package:trail_database/domain/trail_place.dart';
import 'package:trail_database/domain/trail_trophy_any_of_places.dart';
import 'package:trail_database/domain/trail_trophy_exact_unique_checkins.dart';
import 'package:trail_database/domain/trail_trophy_total_checkins_any_place.dart';
import 'package:trail_database/domain/trail_trophy_total_unique_checkins.dart';
import 'package:trail_database/domain/trail_trophy_unique_pct_of_total.dart';
import 'package:trail_database/model/trail_trophy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum TrophyType {
  PercentUniqueOfTotal,
  ExactUniqueCheckins,
  TotalUniqueCheckins,
  TotalCheckinsAtAnyPlace,
  AnyOfPlaces
}

/// Logical representation of a trophy
abstract class TrailTrophy {
  TrailTrophyModel _model;

  TrophyType type;

  String get id => _model.id;
  String get activeImage => _model.activeImage;
  String get inactiveImage => _model.inactiveImage;
  String get name => _model.name;
  String get description => _model.description;
  bool get published => _model.published;

  TrailTrophy({TrailTrophyModel model}) {
    _model = model;
  }

  bool conditionsMet(List<CheckIn> checkins, List<TrailPlace> allPlaces) {
    throw UnimplementedError();
  }

  static TrailTrophy create(
      {String id,
      String trophyType,
      String activeImage,
      String inactiveImage,
      String name,
      String description,
      bool published,
      List<String> requiredCheckIns,
      int percentRequired,
      int uniqueCountRequired,
      int checkinCountRequired,
      List<String> possiblePlaces}) {
    try {
      var model = TrailTrophyModel(
        id: id,
        activeImage: activeImage,
        inactiveImage: inactiveImage,
        name: name,
        description: description,
        trophyType: trophyType,
        published: published,
      );
      TrailTrophy trophy;
      if (model.trophyType == "exact_unique_checkins") {
        trophy = TrailTrophyExactUniqueCheckins(
          model: model,
          requiredCheckins: requiredCheckIns,
        );
        trophy.type = TrophyType.ExactUniqueCheckins;
      } else if (model.trophyType == "pct_unique_of_total") {
        trophy = TrailTrophyPctUniqueOfTotal(
          model: model,
          percentRequired: percentRequired,
        );
        trophy.type = TrophyType.PercentUniqueOfTotal;
      } else if (model.trophyType == "total_unique_checkins") {
        trophy = TrailTrophyTotalUniqueCheckins(
          model: model,
          uniqueCountRequired: uniqueCountRequired,
        );
        trophy.type = TrophyType.TotalUniqueCheckins;
      } else if (model.trophyType == "total_checkins_any_place") {
        trophy = TrailTrophyTotalCheckinsAnyPlace(
          model: model,
          checkinCountRequired: checkinCountRequired,
        );
        trophy.type = TrophyType.TotalCheckinsAtAnyPlace;
      } else if (model.trophyType == "any_of_places") {
        trophy = TrailTrophyAnyOfPlaces(
          model: model,
          possiblePlaces: possiblePlaces,
        );
        trophy.type = TrophyType.AnyOfPlaces;
      } else {
        trophy = null;
      }
      return trophy;
    } catch (e) {
      return null;
    }
  }

  static TrailTrophy fromFirebase(QueryDocumentSnapshot snapshot) {
    try {
      var d = snapshot.data() as Map<String, dynamic>;
      var model = TrailTrophyModel(
        id: snapshot.id,
        activeImage: d['active_image'],
        inactiveImage: d['inactive_image'],
        name: d['name'],
        description: d['description'],
        trophyType: d['type'],
        published: d['published'] ?? false,
      );

      TrailTrophy trophy;
      if (model.trophyType == "exact_unique_checkins") {
        trophy = TrailTrophyExactUniqueCheckins(
          model: model,
          requiredCheckins: List<String>.from(d['req_places']),
        );
        trophy.type = TrophyType.ExactUniqueCheckins;
      } else if (model.trophyType == "pct_unique_of_total") {
        trophy =  TrailTrophyPctUniqueOfTotal(
          model: model,
          percentRequired: d['required_percent'],
        );
        trophy.type = TrophyType.PercentUniqueOfTotal;
      } else if (model.trophyType == "total_unique_checkins") {
        trophy =  TrailTrophyTotalUniqueCheckins(
          model: model,
          uniqueCountRequired: d['unique_count_required'],
        );
        trophy.type = TrophyType.TotalUniqueCheckins;
      } else if (model.trophyType == "total_checkins_any_place") {
        trophy =  TrailTrophyTotalCheckinsAnyPlace(
          model: model,
          checkinCountRequired: d['check_in_count_required'],
        );
        trophy.type = TrophyType.TotalCheckinsAtAnyPlace;
      } else if (model.trophyType == "any_of_places") {
        trophy =  TrailTrophyAnyOfPlaces(
          model: model,
          possiblePlaces: List<String>.from(d["possible_places"]),
        );
        trophy.type = TrophyType.AnyOfPlaces;
      } else {
        trophy =  null;
      }
      return trophy;
    } catch (e) {
      return null;
    }
  }
}
