import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/data/check_in.dart';
import 'package:alabama_beer_trail/data/trail_trophy.dart';
import 'package:flutter/material.dart';

class TrailTrophyPctUniqueOfTotal extends TrailTrophy {
  final int percentRequired;

  TrailTrophyPctUniqueOfTotal({
    @required this.percentRequired,
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
    // Get count of unique checkins
    var uniqueCheckinsCount = checkins.map((f) {
      return f.placeId;
    }).toSet().length;

    return (uniqueCheckinsCount / allPlaces.length)*100 >= percentRequired;
  }
}
