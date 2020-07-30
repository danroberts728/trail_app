import 'package:alabama_beer_trail/data/check_in.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/data/trail_trophy_exact_unique_checkins.dart';
import 'package:alabama_beer_trail/data/trail_trophy_pct_unique_of_total.dart';
import 'package:alabama_beer_trail/data/trail_trophy_total_checkins_any_place.dart';
import 'package:alabama_beer_trail/data/trail_trophy_total_unique_checkins.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum TrophyType { PercentUniqueOfTotal, ExactUniqueCheckins, TotalUniqueCheckins, TotalCheckinsAtAnyPlace }

abstract class TrailTrophy {
  final String id;
  final String activeImage;
  final String inactiveImage;
  final String name;
  final String description;
  final TrophyType trophyType;

  TrailTrophy(
      {@required this.trophyType,
      @required this.id,
      @required this.activeImage,
      @required this.inactiveImage,
      @required this.name,
      @required this.description});

  bool conditionsMet(List<CheckIn> checkins, List<TrailPlace> allPlaces);

  static TrailTrophy createFromFirebase(DocumentSnapshot d) {
    try {
      bool published = d['published'];
      String trophyType = d['type'];
      String docId = d.documentID;
      String activeImage = d['active_image'];
      String inactiveimage = d['inactive_image'];
      String name = d['name'];
      String description = d['description'];

      if(!published) {
        return null;
      } else if (trophyType == "exact_unique_checkins") {
        return TrailTrophyExactUniqueCheckins(
            trophyType: TrophyType.ExactUniqueCheckins,
            requiredCheckins: List<String>.from(d['req_places']),
            id: docId,
            activeImage: activeImage,
            inactiveImage: inactiveimage,
            name: name,
            description: description);
      } else if (trophyType == "pct_unique_of_total") {
        return TrailTrophyPctUniqueOfTotal(
          trophyType: TrophyType.PercentUniqueOfTotal,
          id: docId,
          activeImage: activeImage,
          inactiveImage: inactiveimage,
          name: name,
          description: description,
          percentRequired: d['required_percent'],
        );
      } else if (trophyType == "total_unique_checkins") {
        return TrailTrophyTotalUniqueCheckins(
          trophyType: TrophyType.TotalUniqueCheckins,
          id: docId,
          activeImage: activeImage,
          inactiveImage: inactiveimage,
          name: name,
          description: description,
          uniqueCountRequired: d['unique_count_required'],
        );
      } else if (trophyType == "total_checkins_any_place") {
        return TrailTrophyTotalCheckinsAnyPlace(
          trophyType: TrophyType.TotalCheckinsAtAnyPlace,
          id: docId,
          activeImage: activeImage,
          inactiveImage: inactiveimage,
          name: name,
          description: description,
          checkinCountRequired: d['check_in_count_required'],
        );
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
