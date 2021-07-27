// Copyright (c) 2020, Fermented Software.

/// Database representation of a trail trophy
class TrailTrophyModel {
  final String id;
  final String activeImage;
  final String inactiveImage;
  final String name;
  final String description;
  final String trophyType;
  final bool published;

  TrailTrophyModel({
    this.id,
    this.activeImage,
    this.inactiveImage,
    this.name,
    this.description,
    this.trophyType,
    this.published,
  });
}
