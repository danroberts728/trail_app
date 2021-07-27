// Copyright (c) 2020, Fermented Software.

/// Database representation of a beer on tap
class OnTapBeerModel {
  final String abv;
  final int beerId;
  final String description;
  final int ibu;
  final String logoUrl;
  final String manufacturer;
  final String name;
  final String style;
  final List<dynamic> prices;
  final String untappdUrl;

  OnTapBeerModel(
      {this.abv,
      this.beerId,
      this.description, 
      this.ibu,
      this.logoUrl,
      this.manufacturer,
      this.name,
      this.style,
      this.prices,
      this.untappdUrl});
}
