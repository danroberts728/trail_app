// Copyright (c) 2021, Fermented Software.
import 'dart:math';

import 'package:trail_database/domain/check_in.dart';
import 'package:trail_database/domain/trail_place.dart';
import 'package:trail_database/domain/trail_trophy.dart';
import 'package:trail_database/model/trail_trophy.dart';

/// Trophy of TotalCheckinsAtAnyPlace type
///
/// Conditions met if the user has a checked in to any
/// place at least [checkinCountRequired] number of times
class TrailTrophyTotalCheckinsAnyPlace extends TrailTrophy {
  final TrophyType trophyType = TrophyType.TotalCheckinsAtAnyPlace;
  final int checkinCountRequired;

  TrailTrophyTotalCheckinsAnyPlace({
    TrailTrophyModel model,
    this.checkinCountRequired
  }) : super(
            model: model);

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
