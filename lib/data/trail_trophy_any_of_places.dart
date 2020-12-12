// Copyright (c) 2020, Fermented Software.
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/data/check_in.dart';
import 'package:alabama_beer_trail/data/trail_trophy.dart';
import 'package:flutter/material.dart';

/// Trophy of AnyOfPlaces type
/// 
/// Conditions met if the user has a check in to
/// any of the listed [possiblePlaces]
class TrailTrophyAnyOfPlaces extends TrailTrophy {
  final List<String> possiblePlaces;

  TrailTrophyAnyOfPlaces({
    this.possiblePlaces,
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
    return checkins.any((c) => possiblePlaces.contains(c.placeId));
  }
}
