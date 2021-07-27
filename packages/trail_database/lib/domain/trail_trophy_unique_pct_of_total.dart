// Copyright (c) 2021, Fermented Software.
import 'package:trail_database/domain/check_in.dart';
import 'package:trail_database/domain/trail_place.dart';
import 'package:trail_database/domain/trail_trophy.dart';
import 'package:trail_database/model/trail_trophy.dart';

/// Trophy of PercentUniqueOfTotal type
///
/// Conditions met if the user has a checked in to
/// at least [percentRequired] of possible places
class TrailTrophyPctUniqueOfTotal extends TrailTrophy {
  final TrophyType trophyType = TrophyType.PercentUniqueOfTotal;
  final int percentRequired;

  TrailTrophyPctUniqueOfTotal({
    TrailTrophyModel model,
    this.percentRequired,
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

    if (uniqueCheckinsCount == 0) {
      // Weird error that happens sometimes.
      // We're assuming that this never an actual condition
      return false;
    }

    return uniqueCheckinsCount != 0 &&
        (uniqueCheckinsCount / allPlaces.length) * 100 >= percentRequired;
  }
}
