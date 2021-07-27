// Copyright (c) 2021, Fermented Software.

import 'package:trail_database/domain/check_in.dart';
import 'package:trail_database/domain/trail_place.dart';
import 'package:trail_database/domain/trail_trophy.dart';
import 'package:trail_database/model/trail_trophy.dart';

/// Trophy of AnyOfPlaces type
///
/// Conditions met if the user has a check in to
/// any of the listed [possiblePlaces]
class TrailTrophyAnyOfPlaces extends TrailTrophy {
  final List<String> possiblePlaces;

  TrailTrophyAnyOfPlaces({
    TrailTrophyModel model,
    this.possiblePlaces,
  }) : super(model: model);

  @override
  bool conditionsMet(List<CheckIn> checkins, List<TrailPlace> allPlaces) {
    return checkins.any((c) => possiblePlaces.contains(c.placeId));
  }
}
