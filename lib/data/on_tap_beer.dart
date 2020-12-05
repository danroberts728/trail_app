// Copyright (c) 2020, Fermented Software.

/// Representation of an on_tap entry in the cloud database
class OnTapBeer {
  final String abv;
  final int beerId;
  final String description;
  final int ibu;
  final String logoUrl;
  final String manufacturer;
  final String name;
  final String style;
  final List<OnTapPrice> prices;
  final String untappdUrl;

  OnTapBeer(
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

class OnTapPrice {
  final double price;
  final String name;
  final double volumeOz;

  OnTapPrice(
    {this.price,
    this.name,
    this.volumeOz});
}
