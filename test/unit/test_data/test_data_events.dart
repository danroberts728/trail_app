// Copyright (c) 2020, Fermented Software.
import 'package:beer_trail_app/model/trail_event.dart';
import 'package:flutter/material.dart';

/// Note: DateTime.now is notoriously impossible to mock. See https://github.com/dart-lang/sdk/issues/28985
/// 
/// Instead of implementing the ugly workarounds, we're utilizing extremes. Events 
/// are set in the far future, unless we want them to be in the past.
class TestDataEvents {
  static List<TrailEvent> events = [
    TrailEvent(
      allDayEvent: false,
      color: Color(0xff206177),
      details: "<p>Make plans now to see Otha Allen live the day before Thanksgiving!<br />We know everyone will have family in town so bring the whole fam and we will take care of everything else.<br />This is an outdoor event, please feel free to bring your own chairs.</p>",
      end: DateTime(2099, 10, 21, 0, 0),
      featured: false,
      hideEndTime: false,
      id: "19538",
      imageUrl: "https://storage.googleapis.com/alabama-beer-trail-dab63.appspot.com/event_images/otha-allen.jpg?GoogleAccessId=alabama-beer-trail-dab63%40appspot.gserviceaccount.com&Expires=1604620800&Signature=ntjrYvm7xOnVikKwwYMfFQcB7jjXU5sk7Ky%2FCa0uhgzz52OCeOq5K8vVQNHXWL6OW%2BH6iOCdFjTq9Qquc98jIRJNjEKHCfFV8h5i37Ml%2Bz22qKRNqg9wZktwU2btc6CKYqVORXZ7ucHNxnMkRqt%2FrVGybXZIZGHBYMRK%2BRwtLqvGccYvQnDupHf2k%2B0WdMwn%2BVLnGI%2B5B3UKggRbBfwE3YXwWNuh6zZIT4P6EA3kpJSZbxpYuosTDjpObzawHj%2BZH8LFm1Y06FA51EhuBta87va1%2Fg%2BVLUVUNJ4YsnR%2Fw1X6J3Z2x2fZzrPlt%2FUWC5hBT8RfoT%2Bh6ss0DNraokaS5Q%3D%3D",
      learnMoreLink: "",
      locationAddress: "153 Mary Lou Lane, Dothan, AL 36301",
      locationCity: null,
      locationLat: 33.5275743,
      locationLon: -86.7651301,
      locationName: "Folkllore Brewing & Meadery",
      locationState: "AL",
      locationTaxonomy: 58,
      name: "Otha Allen Live",
      start: DateTime(2099, 10, 20, 19, 0),
      status: 'publish',
    ),
    TrailEvent(
      allDayEvent: false,
      color: Color(0xff206177),
      details: "<p>Thirsty Thursdays just got spookier! Join us as we celebrate the Halloween season with some spooky crafts. We will have Halloween wood burnt magnets, resin skulls, and skeleton figures. In addition we will have other vendors carrying a variety of crafts, coasters, and more. Shop local while enjoying some great food and brews from Straight to Ale! Wear your mask and practice social distancing!</p>",
      end: DateTime(2099, 10, 16, 22, 0),
      featured: false,
      hideEndTime: false,
      id: "19304",
      imageUrl: "https://freethehops.org/wp-content/uploads/sites/7/2020/09/120082092_828208721318258_7297398023838352522_n-768x1024-1.jpg",
      learnMoreLink: "",
      locationAddress: "2610 Clinton Ave NW, Huntsville, AL 35805",
      locationCity: "Huntsville",
      locationLat: 34.721106,
      locationLon: -86.606239,
      locationName: "Straight to Ale Brewing",
      locationState: "AL",
      locationTaxonomy: 43,
      name: "Spooktacular Art Masquerade",
      start: DateTime(2099, 10, 16, 19, 0),
      status: 'publish',
    ),
    TrailEvent(
      allDayEvent: false,
      color: Color(0xff206177),
      details: "<p>Make plans now to see Otha Allen live the day before Thanksgiving!<br />We know everyone will have family in town so bring the whole fam and we will take care of everything else.<br />This is an outdoor event, please feel free to bring your own chairs.</p>",
      end: DateTime(2099, 10, 21, 0, 0),
      featured: false,
      hideEndTime: false,
      id: "19538",
      imageUrl: "https://storage.googleapis.com/alabama-beer-trail-dab63.appspot.com/event_images/otha-allen.jpg?GoogleAccessId=alabama-beer-trail-dab63%40appspot.gserviceaccount.com&Expires=1604620800&Signature=ntjrYvm7xOnVikKwwYMfFQcB7jjXU5sk7Ky%2FCa0uhgzz52OCeOq5K8vVQNHXWL6OW%2BH6iOCdFjTq9Qquc98jIRJNjEKHCfFV8h5i37Ml%2Bz22qKRNqg9wZktwU2btc6CKYqVORXZ7ucHNxnMkRqt%2FrVGybXZIZGHBYMRK%2BRwtLqvGccYvQnDupHf2k%2B0WdMwn%2BVLnGI%2B5B3UKggRbBfwE3YXwWNuh6zZIT4P6EA3kpJSZbxpYuosTDjpObzawHj%2BZH8LFm1Y06FA51EhuBta87va1%2Fg%2BVLUVUNJ4YsnR%2Fw1X6J3Z2x2fZzrPlt%2FUWC5hBT8RfoT%2Bh6ss0DNraokaS5Q%3D%3D",
      learnMoreLink: "",
      locationAddress: "153 Mary Lou Lane, Dothan, AL 36301",
      locationCity: null,
      locationLat: 31.148755,
      locationLon: -85.395375,
      locationName: "Folkllore Brewing & Meadery",
      locationState: "AL",
      locationTaxonomy: 58,
      name: "Otha Allen Live",
      start: DateTime(2099, 10, 20, 19, 0),
      status: 'publish',
    ),
  ];
}