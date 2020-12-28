// Copyright (c) 2020, Fermented Software.
import 'package:alabama_beer_trail/data/on_tap_beer.dart';

class TestDataTaps {
  static List<OnTapBeer> getTaps(String placeId) {
    if (placeId == 'sta') {
      return [
        OnTapBeer(
            abv: "9.2",
            ibu: 0,
            logoUrl:
                "https://s3.amazonaws.com/digitalpourproducerlogos/5df2b1b2352726127c7ff0ae.png",
            manufacturer: "Druid City",
            name: "Parkview Porter",
            style: "Porter"),
      ];
    } else {
      return <OnTapBeer>[];
    }
  }
}
