// Copyright (c) 2021, Fermented Software.

/// Database representation of a trail region
class TrailRegionModel {
  final String id;
  final String name;
  final List<String> places;
  final bool published;
  final int sortOrder;

  TrailRegionModel({
    this.id,
    this.name,
    this.places,
    this.published,
    this.sortOrder,
  });
}
