// Copyright (c) 2020, Fermented Software.

/// Data representation of a beer
class Beer {
  final double abv;
  final String description;
  final int ibu;
  final String labelUrl;
  final String name;
  final String style;
  final bool isInProduction;
  final int untappdId;
  final int untappdRatingCount;
  final double untappdRatingScore;

  /// Default constructor
  Beer(
      {this.abv,
      this.description,
      this.ibu,
      this.labelUrl,
      this.name,
      this.style,
      this.isInProduction,
      this.untappdId,
      this.untappdRatingCount,
      this.untappdRatingScore});
}
