// Copyright (c) 2020, Fermented Software.

/// Representation of an on_tap entry in the cloud database
class OnTapBeer {
  final String abv;
  final int ibu;
  final String logoUrl;
  final String manufacturer;
  final String name;
  final String style;

  OnTapBeer(
      {this.abv,
      this.ibu,
      this.logoUrl,
      this.manufacturer,
      this.name,
      this.style});
}
