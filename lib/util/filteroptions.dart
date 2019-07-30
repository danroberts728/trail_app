class FilterOptions {
  final SortOrder sort;
  final Map<String, bool> show;

  FilterOptions(this.sort, this.show);
}

enum SortOrder {
  ALPHABETICAL,
  DISTANCE,
}