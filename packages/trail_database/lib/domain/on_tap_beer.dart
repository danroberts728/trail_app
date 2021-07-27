// Copyright (c) 2021, Fermented Software.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trail_database/model/on_tap_beer.dart';

/// Logical representation of an On Tap Beer
class OnTapBeer {
  OnTapBeerModel _model;
  String get abv => _model.abv;
  String get description => _model.description;
  int get ibu => _model.ibu;
  String get logoUrl => _model.logoUrl;
  String get manufacturer => _model.manufacturer;
  String get name => _model.name;
  String get style => _model.style;
  String get untappdUrl => _model.untappdUrl;

  List<OnTapPrice> get prices {
    return List<OnTapPrice>.from(_model.prices);
  }

  OnTapBeer({OnTapBeerModel model}) {
    _model = model;
  }

  static OnTapBeer create({
    String abv,
    String description,
    int ibu,
    String logoUrl,
    String manufacturer,
    String name,
    String style,
    String untappdUrl,
  }) {
    return OnTapBeer(
        model: OnTapBeerModel(
      abv: abv,
      description: description,
      ibu: ibu,
      logoUrl: logoUrl,
      manufacturer: manufacturer,
      name: name,
      style: style,
      untappdUrl: untappdUrl,
    ));
  }

  /// Creates an OnTapBeer from a query document snapshot from firebase
  ///
  /// Returns null if the beer does not find a name or untappd ID
  static OnTapBeer fromFirebase(QueryDocumentSnapshot snapshot) {
    try {
      var d = snapshot.data() as Map<String, dynamic>;
      var onTapBeerModel = OnTapBeerModel(
        abv: d['abv'] == null ? "" : d['abv'],
        beerId: d['beer_id'] == null ? 0 : d['beer_id'],
        description: d['description'] == null ? "" : d['description'],
        prices: d['prices'] == null
            ? <OnTapPrice>[]
            : List<OnTapPrice>.from(d['prices'].map((item) {
                return OnTapPrice(
                    name: item['serving_size_name'],
                    price: double.tryParse(item['price']),
                    volumeOz: double.tryParse(item['serving_size_volume_oz']));
              })),
        ibu: d['ibu'] == null ? 0 : d['ibu'],
        logoUrl: d['logo_url'] == null ? "" : d['logo_url'],
        manufacturer:
            d['manufacturer_name'] == null ? "" : d['manufacturer_name'],
        name: d['name'] == null ? "" : d['name'],
        style: d['style'] == null ? "" : d['style'],
        untappdUrl: d['untappd_url'] == null ? "" : d['untappd_url'],
      );
      if (onTapBeerModel.name == "") {
        return null;
      } else {
        return OnTapBeer(model: onTapBeerModel);
      }
    } catch (err) {
      return null;
    }
  }
}

class OnTapPrice {
  double price;
  String name;
  double volumeOz;

  OnTapPrice({this.price, this.name, this.volumeOz});
}
