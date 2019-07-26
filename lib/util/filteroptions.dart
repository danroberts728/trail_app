class FilterOptions {
  final SortOrder sort;

  FilterOptions(this.sort);
}

enum SortOrder {
  ALPHABETICAL,
  DISTANCE,
}