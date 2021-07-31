class TrailTrophy {
  final String id;
  final String activeImageUrl;
  final String description;
  final String inactiveImageUrl;
  final String name;
  final bool published;
  final int sortOrder;
  final TrophyType type;

  final List<String> requiredPlaces;
  final double requiredPercent;
  final int checkInCountRequired;
  final int uniqueCountRequired;
  final List<String> possiblePlaces;

  TrailTrophy({
    this.id,
    this.activeImageUrl,
    this.description,
    this.inactiveImageUrl,
    this.name,
    this.published,
    this.sortOrder,
    this.type,
    this.requiredPlaces,
    this.requiredPercent,
    this.checkInCountRequired,
    this.uniqueCountRequired,
    this.possiblePlaces,
  });
}

class TrailTrophyExactUniqueCheckins extends TrailTrophy {
  final List<String> requiredPlaces;

  TrailTrophyExactUniqueCheckins({this.requiredPlaces});
}

enum TrophyType {
  ExactUniqueCheckins,
  PercentUniqueOfTotal,
  TotalCheckInsAnyPlace,
  TotalUniqueCheckins,
  AnyOfPlaces
}

extension TrophyTypeExtension on TrophyType {
  String get name {
    switch (this) {
      case TrophyType.AnyOfPlaces:
        return "Any of Places";
      case TrophyType.PercentUniqueOfTotal:
        return "Percent Unique of Total";
      case TrophyType.TotalCheckInsAnyPlace:
        return "Total Check Ins Any Place";
      case TrophyType.TotalUniqueCheckins:
        return "Total Unique CheckIns";
      case TrophyType.ExactUniqueCheckins:
        return "Exact Unique Checkins";
      default:
        return null;
    }
  }

  String get description {
    switch (this) {
      case TrophyType.AnyOfPlaces:
        return "User has checked in to any of a list of places";
      case TrophyType.PercentUniqueOfTotal:
        return "User has checked in to a certain percent of the possible trail places";
      case TrophyType.TotalCheckInsAnyPlace:
        return "User has checked in to any single place a certain number of times";
      case TrophyType.TotalUniqueCheckins:
        return "User has checked in to a certain number of unique places";
      case TrophyType.ExactUniqueCheckins:
        return "User has checked in to all of a list of places";
      default:
        return null;
    }
  }

  String get dbKey {
    switch (this) {
      case TrophyType.AnyOfPlaces:
        return "any_of_places";
      case TrophyType.PercentUniqueOfTotal:
        return "pct_unique_of_total";
      case TrophyType.TotalCheckInsAnyPlace:
        return "total_checkins_any_place";
      case TrophyType.TotalUniqueCheckins:
        return "total_unique_checkins";
      case TrophyType.ExactUniqueCheckins:
        return "exact_unique_checkins";
      default:
        return null;
    }
  }
}
