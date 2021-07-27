// Copyright (c) 2021, Fermented Software.
import 'package:trail_database/domain/check_in.dart';
import 'package:trail_database/domain/trail_place.dart';
import 'package:trail_database/domain/trail_trophy.dart';
import 'package:trail_database/model/trail_trophy.dart';

/// Trophy of TotalUniqueCheckins type
///
/// Conditions met if the user has a checked in to
/// at least [uniqueCountRequired] places
class TrailTrophyTotalUniqueCheckins extends TrailTrophy {
  final TrophyType trophyType = TrophyType.TotalUniqueCheckins;
  final int uniqueCountRequired;

  TrailTrophyTotalUniqueCheckins({
    TrailTrophyModel model,
    this.uniqueCountRequired,
  }) : super(model: model);

  @override
  bool conditionsMet(List<CheckIn> checkins, List<TrailPlace> allPlaces) {
    // Get count of unique checkins
    var uniqueCheckinsCount = checkins
        .map((f) {
          return f.placeId;
        })
        .toSet()
        .length;

    return uniqueCheckinsCount >= this.uniqueCountRequired;
  }
}
