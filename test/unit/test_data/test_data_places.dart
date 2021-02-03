// Copyright (c) 2020, Fermented Software.
import 'dart:math';

import 'package:beer_trail_app/data/trail_place.dart';

/// To use:
/// import '../test_data/test_data_places.dart' as testPlaces;
/// List<TrailPlace> testPlacesData = testPlaces.TestDataPlaces.places;
class TestDataPlaces {
  static List<TrailPlace> places = [
    TrailPlace(
      id: 'cahaba',
      name: 'Cahaba Brewing Co',
      address: "405 5th Ave S BLDG C",
      categories: ["Brewery", "Distillery", "Tasting Room"],
      city: "Birmingham",
      connections: {
        'facebook': '215124531887627',
        'instagram': 'https://www.instagram.com/cahababrewing/',
        'twitter': 'https://twitter.com/cahababrewing',
        'untappd': '30313',
        'website': 'https://cahababrewing.com/',
      },
      description:
          "<p>Since the beginning, Cahaba Brewing Company has had the goal of providing the craft beer community with clean and consistent brews with a broad variety of flavors and styles.</p>",
      emails: {},
      featuredImgUrl:
          "https://firebasestorage.googleapis.com/v0/b/alabama-beer-trail-dab63.appspot.com/o/gallery%2Fcahaba.jpg?alt=media&token=4a3397e2-3086-4226-8c2e-bd318a55abce",
      galleryUrls: [
        "https://firebasestorage.googleapis.com/v0/b/alabama-beer-trail-dab63.appspot.com/o/gallery%2Fcahaba1.jpg?alt=media&token=63865abd-8b62-45fd-a64b-695ba11a7cb6",
        "https://firebasestorage.googleapis.com/v0/b/alabama-beer-trail-dab63.appspot.com/o/gallery%2Fcahaba2.jpg?alt=media&token=9f0e946f-7f2f-4655-aa01-052b9ae456e2",
        "https://firebasestorage.googleapis.com/v0/b/alabama-beer-trail-dab63.appspot.com/o/gallery%2Fcahaba3.jpg?alt=media&token=65191c75-3d83-4015-be43-42123e83101c",
      ],
      hours: {
        "monday": "3:00 – 10:00 PM",
        "sunday": "12:00 – 8:00 PM",
        "friday": "12:00 PM – 12:00 AM",
        "tuesday": "3:00 – 10:00 PM",
        "wednesday": "3:00 – 10:00 PM",
        "thursday": "3:00 – 10:00 PM",
        "saturday": "12:00 PM – 12:00 AM"
      },
      hoursDetail: [
        {
          "close": {"day": 0, "time": "2000"},
          "open": {"time": "1200", "day": 0}
        },
        {
          "close": {"day": 1, "time": "2200"},
          "open": {"time": "1500", "day": 1}
        },
        {
          "open": {"day": 2, "time": "1500"},
          "close": {"day": 2, "time": "2200"}
        },
        {
          "close": {"time": "2200", "day": 3},
          "open": {"time": "1500", "day": 3}
        },
        {
          "close": {"day": 4, "time": "2200"},
          "open": {"time": "1500", "day": 4}
        },
        {
          "open": {"day": 5, "time": "1200"},
          "close": {"day": 6, "time": "0000"}
        },
        {
          "open": {"day": 6, "time": "1200"},
          "close": {"day": 0, "time": "0000"}
        }
      ],
      isMember: true,
      location: Point(33.5275743, -86.7651301),
      locationTaxonomy: 70,
      logoUrl:
          "https://firebasestorage.googleapis.com/v0/b/alabama-beer-trail-dab63.appspot.com/o/logos%2Fcahaba-logo.png?alt=media&token=89ff8e76-50bd-4631-bab2-6db3eb957aa5",
      phones: {"Taproom": "(205) 578-2616"},
      state: "AL",
      zip: "35222",
    ),
    TrailPlace(
      id: 'sta',
      name: 'Straight to Ale',
      address: "2610 Clinton Ave",
      categories: ["Brewery", "Distillery", "Tasting Room", "Winery"],
      city: "Huntsville",
      connections: {
        'facebook': '106235841469',
        'instagram': 'https://www.instagram.com/straighttoale/',
        'twitter': 'https://twitter.com/StraightToAle',
        'untappd': '1739',
        'website': 'https://straighttoale.com/',
      },
      description:
          "Founded by local home brewers in 2009, Straight to Ale has quickly grown to become one of Alabama’s largest production breweries. In the summer of 2016 we opened our new 45,000 square foot facility at Campus 805, reclaiming a long vacant Middle School campus on the edge of downtown Huntsville and turning it into a thriving community of breweries, bars, restaurants, and local shops. At this new location, we expanded to include cider and mead production along with distilled spirits (Shelta Cavern Spirits), a scratch made kitchen (Ale’s Kitchen), a pinball arcade and pool room (Ronnie Rayguns).",
      emails: {},
      featuredImgUrl:
          "https://firebasestorage.googleapis.com/v0/b/alabama-beer-trail-dab63.appspot.com/o/gallery%2Fsta-tasters.jpg?alt=media&token=8efe474b-f9b7-4d03-b690-8419f7f629d2",
      galleryUrls: [
        "https://firebasestorage.googleapis.com/v0/b/alabama-beer-trail-dab63.appspot.com/o/gallery%2Fofest.jpg?alt=media&token=2e114981-c8f4-47a7-a5dd-0d7b1e99980d",
        "https://firebasestorage.googleapis.com/v0/b/alabama-beer-trail-dab63.appspot.com/o/gallery%2Fsta-cans.jpg?alt=media&token=278fb56d-ac1e-4836-9527-e8052d6ca218",
        "https://firebasestorage.googleapis.com/v0/b/alabama-beer-trail-dab63.appspot.com/o/gallery%2Fcafe.jpg?alt=media&token=7f57f9d2-fa6a-429f-bfc1-7b77ac2cb384",
      ],
      hours: {
        "tuesday": "11:00 AM – 9:00 PM",
        "wednesday": "11:00 AM – 9:00 PM",
        "thursday": "11:00 AM – 9:00 PM",
        "sunday": "11:00 AM – 8:00 PM",
        "saturday": "11:00 AM – 9:00 PM",
        "monday": "11:00 AM – 9:00 PM",
        "friday": "11:00 AM – 9:00 PM"
      },
      hoursDetail: [
        {
          "open": {"day": 0, "time": "1100"},
          "close": {"day": 0, "time": "2000"}
        },
        {
          "close": {"time": "2100", "day": 1},
          "open": {"day": 1, "time": "1100"}
        },
        {
          "open": {"day": 2, "time": "1100"},
          "close": {"day": 2, "time": "2100"}
        },
        {
          "open": {"day": 3, "time": "1100"},
          "close": {"day": 3, "time": "2100"}
        },
        {
          "open": {"day": 4, "time": "1100"},
          "close": {"day": 4, "time": "2100"}
        },
        {
          "close": {"day": 5, "time": "2100"},
          "open": {"day": 5, "time": "1100"}
        },
        {
          "open": {"time": "1100", "day": 6},
          "close": {"day": 6, "time": "2100"}
        }
      ],
      isMember: true,
      location: Point(34.720852, -86.607087),
      locationTaxonomy: 43,
      logoUrl:
          "https://firebasestorage.googleapis.com/v0/b/alabama-beer-trail-dab63.appspot.com/o/logos%2Fstraighttoale-logo.png?alt=media&token=1cc44bc9-7f38-46ff-b394-475143bdaf89",
      phones: {"Taproom": "(256) 801-9650"},
      state: "AL",
      zip: "35805",
    ),
    TrailPlace(
      id: 'braided-river',
      name: 'Braided River Brewing Co',
      address: "420 St Louis St",
      categories: ["Brewery", "Tasting Room"],
      city: "Mobile",
      connections: {
        'facebook': '',
        'instagram': '',
        'twitter': '',
        'untappd': '',
        'website': '',
      },
      description:
          "Braided River makes flavorful craft beer designed to pair with the Gulf Coast lifestyle. We want beer that goes along no matter where the adventure takes us, and that doesn’t make us choose between great beer and drinkability.",
      emails: {},
      featuredImgUrl:
          "https://firebasestorage.googleapis.com/v0/b/alabama-beer-trail-dab63.appspot.com/o/gallery%2Fsta-tasters.jpg?alt=media&token=8efe474b-f9b7-4d03-b690-8419f7f629d2",
      galleryUrls: [
        "https://firebasestorage.googleapis.com/v0/b/alabama-beer-trail-dab63.appspot.com/o/gallery%2Fofest.jpg?alt=media&token=2e114981-c8f4-47a7-a5dd-0d7b1e99980d",
        "https://firebasestorage.googleapis.com/v0/b/alabama-beer-trail-dab63.appspot.com/o/gallery%2Fsta-cans.jpg?alt=media&token=278fb56d-ac1e-4836-9527-e8052d6ca218",
        "https://firebasestorage.googleapis.com/v0/b/alabama-beer-trail-dab63.appspot.com/o/gallery%2Fcafe.jpg?alt=media&token=7f57f9d2-fa6a-429f-bfc1-7b77ac2cb384",
      ],
      hours: null,
      hoursDetail: null,
      isMember: true,
      location: Point(30.692714, -88.048255),
      locationTaxonomy: 85,
      logoUrl:
          "https://firebasestorage.googleapis.com/v0/b/alabama-beer-trail-dab63.appspot.com/o/logos%2Fstraighttoale-logo.png?alt=media&token=1cc44bc9-7f38-46ff-b394-475143bdaf89",
      phones: null,
      state: "AL",
      zip: "36602",
    ),
  ];
}
