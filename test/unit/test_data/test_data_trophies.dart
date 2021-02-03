// Copyright (c) 2020, Fermented Software.
import 'package:beer_trail_app/data/trail_trophy.dart';
import 'package:beer_trail_app/data/trail_trophy_any_of_places.dart';
import 'package:beer_trail_app/data/trail_trophy_exact_unique_checkins.dart';
import 'package:beer_trail_app/data/trail_trophy_pct_unique_of_total.dart';
import 'package:beer_trail_app/data/trail_trophy_total_checkins_any_place.dart';
import 'package:beer_trail_app/data/trail_trophy_total_unique_checkins.dart';

/// To use:
/// import '../test_data/test_data_trophies.dart' as testDataTrophies;
/// List<TrailTrophy> testTrophyData = testDataTrophies.TestDataTrophies.trophies;
class TestDataTrophies {
  static List<TrailTrophy> trophies = [
    TrailTrophyExactUniqueCheckins(
      trophyType: TrophyType.ExactUniqueCheckins,
      id: 'bhm-brewery-crawler',
      activeImage: "http://freethehops.org/active.png",
      inactiveImage: "http://freethehops.org/inactive.png",
      name: "Iron City Brewery Crawler",
      description: "Check in to every brewery in the City of Birmingham.",
      requiredCheckins: <String>[
        'avondale',
        'b40-bham',
        'bham-district',
        'cahaba',
        'dread-river',
        'ghost-train',
        'good-people',
        'trimtab',
        'true-story',
        'monday-night',
      ],
    ),
    TrailTrophyPctUniqueOfTotal(
      trophyType: TrophyType.PercentUniqueOfTotal,
      id: 'champion',
      activeImage: "http://freethehops.org/active.png",
      inactiveImage: "http://freethehops.org/inactive.png",
      name: "Alabama Beer Trail Champion",
      description: "Visit Every Alabama brewery",
      percentRequired: 100,
    ),
    TrailTrophyTotalCheckinsAnyPlace(
      trophyType: TrophyType.AnyOfPlaces,
      id: 'favorite_watering_hole',
      activeImage: "http://freethehops.org/active.png",
      inactiveImage: "http://freethehops.org/inactive.png",
      name: "Favorite Watering Hole",
      description: "Check into any single brewery at least 25 times",
      checkinCountRequired: 25,
    ),
    TrailTrophyTotalUniqueCheckins(
      trophyType: TrophyType.TotalUniqueCheckins,
      id: 'journey-begins',
      activeImage: "http://freethehops.org/active.png",
      inactiveImage: "http://freethehops.org/inactive.png",
      name: "The Journey Begins",
      description: "Check into your first brewery",
      uniqueCountRequired: 1,
    ),
    TrailTrophyAnyOfPlaces(
        trophyType: TrophyType.AnyOfPlaces,
        id: 'off-the-beaten-path',
        activeImage: "http://freethehops.org/active.png",
        inactiveImage: "http://freethehops.org/inactive.png",
        name: "Off the Beaten Path",
        description: "Check in to any brewery in a one-brewery town",
        possiblePlaces: <String>[
          'oversoul',
          'goat-island',
          'b40',
          'main-channel',
          'xeo',
          'singin-river',
          'chattahoochee',
          'folklore',
          'fairhope',
          'gts-on-the-bay',
        ]),
  ];
}
