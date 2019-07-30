import 'package:beer_trail_app/util/trailplacecategory.dart';

class FilterOptions {
  final SortOrder sort;
  final Map<TrailPlaceCategory, bool> show;

  FilterOptions(this.sort, this.show);
}

enum SortOrder {
  ALPHABETICAL,
  DISTANCE,
}