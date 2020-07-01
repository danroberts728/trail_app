import 'package:alabama_beer_trail/data/check_in.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/data/trail_trophy_exact_unique_checkins.dart';
import 'package:alabama_beer_trail/data/trail_trophy_pct_unique_of_total.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum TrophyType { PercentUniqueOfTotal, ExactUniqueCheckins }

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
      String trophyType = d['type'];
      String docId = d.documentID;
      String activeImage = d['active_image'];
      String inactiveimage = d['inactive_image'];
      String name = d['name'];
      String description = d['description'];

      if (trophyType == "exact_unique_checkins") {
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
      } else {
        return null;
      }
    } catch (e) {
      throw e;
    }
  }
}
