import 'dart:math';

import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/data/check_in.dart';
import 'package:alabama_beer_trail/data/trail_trophy.dart';
import 'package:flutter/material.dart';

class TrailTrophyTotalCheckinsAnyPlace extends TrailTrophy {
  final int checkinCountRequired;

  TrailTrophyTotalCheckinsAnyPlace({
    @required this.checkinCountRequired,
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
  bool conditionsMet(List<CheckIn> checkins, List<TrailPlace> allPlaces) {
    Map<String, int> checkinsPerPlace = Map<String, int>();
    checkins.forEach((f) { 
      if(checkinsPerPlace.containsKey(f.placeId)) {
        checkinsPerPlace[f.placeId] += 1;
      } else {
        checkinsPerPlace[f.placeId] = 1;
      }
    });

    return checkinsPerPlace.values.reduce(max) >= this.checkinCountRequired;
  }
}
