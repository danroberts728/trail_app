// Copyright (c) 2021, Fermented Software.
import 'package:trail_database/domain/check_in.dart';
import 'package:trail_database/domain/trail_place.dart';
import 'package:trail_database/domain/trail_trophy.dart';
import 'package:trail_database/model/trail_trophy.dart';

/// Trophy of ExactUniqueCheckins type
///
/// Conditions met if the user has a check in all
/// of the [requiredCheckins]
class TrailTrophyExactUniqueCheckins extends TrailTrophy {
  final TrophyType trophyType = TrophyType.ExactUniqueCheckins;
  final List<String> requiredCheckins;

  TrailTrophyExactUniqueCheckins(
      {TrailTrophyModel model, this.requiredCheckins})
      : super(model: model);

  @override
  bool conditionsMet(List<CheckIn> checkins, List<TrailPlace> places) {
    // Get set of unique checkins
    var uniqueCheckins = checkins.map((f) {
      return f.placeId;
    }).toSet();

    return this.requiredCheckins.every((req) => uniqueCheckins.contains(req));
  }
}
