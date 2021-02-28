// Copyright (c) 2020, Fermented Software.
import 'package:beer_trail_database/domain/trail_trophy.dart';

/// To use:
/// import '../test_data/test_data_trophies.dart' as testDataTrophies;
/// List<TrailTrophy> testTrophyData = testDataTrophies.TestDataTrophies.trophies;
class TestDataTrophies {
  static List<TrailTrophy> trophies = [
    TrailTrophy.create(
      trophyType: "exact_unique_checkins",
      id: 'bhm-brewery-crawler',
      activeImage: "http://freethehops.org/active.png",
      inactiveImage: "http://freethehops.org/inactive.png",
      name: "Iron City Brewery Crawler",
      description: "Check in to every brewery in the City of Birmingham.",
      requiredCheckIns: <String>[
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
    TrailTrophy.create(
      trophyType: "pct_unique_of_total",
      id: 'champion',
      activeImage: "http://freethehops.org/active.png",
      inactiveImage: "http://freethehops.org/inactive.png",
      name: "Alabama Beer Trail Champion",
      description: "Visit Every Alabama brewery",
      percentRequired: 100,
    ),
    TrailTrophy.create(
      trophyType: "any_of_places",
      id: 'favorite_watering_hole',
      activeImage: "http://freethehops.org/active.png",
      inactiveImage: "http://freethehops.org/inactive.png",
      name: "Favorite Watering Hole",
      description: "Check into any single brewery at least 25 times",
      checkinCountRequired: 25,
    ),
    TrailTrophy.create(
      trophyType: "total_unique_checkins",
      id: 'journey-begins',
      activeImage: "http://freethehops.org/active.png",
      inactiveImage: "http://freethehops.org/inactive.png",
      name: "The Journey Begins",
      description: "Check into your first brewery",
      uniqueCountRequired: 1,
    ),
    TrailTrophy.create(
        trophyType: "any_of_places",
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
