import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/model/check_in.dart';
import 'package:alabama_beer_trail/data/trail_trophy.dart';
import 'package:flutter/material.dart';

class TrailTrophyExactUniqueCheckins extends TrailTrophy {
  final List<String> requiredCheckins;

  TrailTrophyExactUniqueCheckins({
    @required this.requiredCheckins,
    @required String id,
    @required String activeImage,
    @required String inactiveImage,
    @required String name,
    @required String description,
    @required TrophyType trophyType,
  }) : super(
            id: id,
            activeImage: activeImage,
            inactiveImage: inactiveImage,
            name: name,
            description: description,
            trophyType: trophyType);

  @override
  bool conditionsMet(List<CheckIn> checkins, List<TrailPlace> places) {
    // Get set of unique checkins
    var uniqueCheckins = checkins.map((f) {
      return f.placeId;
    }).toSet();

    return this.requiredCheckins.every((req) => uniqueCheckins.contains(req));
  }
}
