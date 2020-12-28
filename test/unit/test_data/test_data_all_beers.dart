// Copyright (c) 2020, Fermented Software.
import 'package:alabama_beer_trail/data/beer.dart';

class TestDataAllBeers {
  static List<Beer> getPopularBeers(String placeId) {
    if (placeId == 'sta') {
      return [
        Beer(
          abv: 4.2,
          description:
              "From 1948-1952 Six Primates all named Albert were used in Pioneering Space Travel, this is Straight to Ale's brew used to Pioneer a path for  flavorful Session IPA in the craft scene.Full of Citra & Amarillo Hops w/ a Huge Tropical Fruit Nose.",
          ibu: 0,
          isInProduction: true,
          labelUrl:
              'https://untappd.akamaized.net/site/beer_logos/beer-1250656_a740a_sm.jpeg',
          name: '6 Alberts',
          style: 'IPA - Session / India Session Ale',
          untappdId: 1250656,
          untappdRatingCount: 2629,
          untappdRatingScore: 3.628,
        ),
      ];
    } else {
      return <Beer>[];
    }
  }
}
