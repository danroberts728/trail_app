// Copyright (c) 2020, Fermented Software.
import 'package:beer_trail_database/domain/trail_place.dart';
import 'package:beer_trail_database/domain/trail_trophy.dart';

/// A simple data object representing an
/// activity
class ActivityItem {
  final DateTime date;
  final TrailPlace place;
  final TrailTrophy trophy;
  final ActivityType type;
  final String userDisplayName;
  final String userImageUrl;

  ActivityItem(
      {this.date,
      this.place,
      this.trophy,
      this.type = ActivityType.CheckIn,
      this.userImageUrl = "",
      this.userDisplayName = ""});
}

enum ActivityType { CheckIn, TrophyAward }
