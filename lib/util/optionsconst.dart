import 'package:alabama_beer_trail/util/trailplacecategory.dart';

class OptionsConst {
  final bool navBarShowSelectedLabels = true;
  final bool navBarShowUnselectedLabels = false;
  final String newsScreenRssFeedUrl = 'https://freethehops.org/category/announcements/feed/';
  final String defaultThumbnailUrl = 'https://freethehops.org/wp-content/uploads/sites/7/2019/05/FTH-Pocket-Logo-Teal-Front-cropped-150x150.jpeg';
  final int locationUpdatesIntervalMs = 5000;
  final double locationDisplacementFilterM = 10.0;
  final double minDistanceToCheckin = 0.15;
  final List<TrailPlaceCategory> filterStrings = <TrailPlaceCategory> [
    TrailPlaceCategory("Brewery", "Breweries"),
    TrailPlaceCategory("Distillery", "Distilleries"),
    TrailPlaceCategory("Tasting Room", "Tasting Rooms"),
    TrailPlaceCategory("Restaurant", "Restaurants"),
    TrailPlaceCategory("Beer Bar", "Beer Bars"),
  ];
}