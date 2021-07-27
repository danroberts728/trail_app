// Copyright (c) 2020, Fermented Software.
import 'dart:math';

import 'package:trail_location_service/trail_location_service.dart';
import 'package:trailtab_events/bloc/trailtab_events_bloc.dart';
import 'package:trail_database/trail_database.dart';
import 'package:trailtab_events/util/event_filter.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;


class TrailDatabaseMock extends Mock implements TrailDatabase {}
class LocationServiceMock extends Mock implements TrailLocationService {}
class EventFilterMock extends Mock implements EventFilter {}
class StreamMock<T> extends Mock implements Stream<T> {}

void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();
  TrailDatabaseMock databaseMock = TrailDatabaseMock();
  LocationServiceMock locationServiceMock = LocationServiceMock();
  EventFilterMock eventFilterMock5 = EventFilterMock();
  EventFilterMock eventFilterMock25 = EventFilterMock();
  EventFilterMock eventFilterMock50 = EventFilterMock();
  EventFilterMock eventFilterMock100 = EventFilterMock();
  EventFilterMock eventFilterMockAll = EventFilterMock();


  setUp(() {
    when(databaseMock.events).thenReturn(TestDataEvents.events);
    when(databaseMock.eventsStream).thenAnswer((_) => StreamMock());

    when(locationServiceMock.lastLocation).thenAnswer((_) => Point(33.5275743, -86.7651301)); // Cahaba Location
    when(locationServiceMock.locationStream).thenAnswer((_) => StreamMock());

    when(eventFilterMock5.distance).thenReturn(5.0);
    when(eventFilterMock25.distance).thenReturn(25.0);
    when(eventFilterMock50.distance).thenReturn(50.0);
    when(eventFilterMock100.distance).thenReturn(100.0);
    when(eventFilterMockAll.distance).thenReturn(double.infinity);
    when(eventFilterMock5.stream).thenAnswer((_) => StreamMock());
    when(eventFilterMock25.stream).thenAnswer((_) => StreamMock());
    when(eventFilterMock50.stream).thenAnswer((_) => StreamMock());
    when(eventFilterMock100.stream).thenAnswer((_) => StreamMock());
    when(eventFilterMockAll.stream).thenAnswer((_) => StreamMock());
  });

  group("Constructor tests", () {
    test("DB cannot be null", () {
      expect(() => TrailTabEventsBloc(null, eventFilterMockAll, locationServiceMock),
          throwsA(anything));
    });

    test("Filter cannot be null", () {
      expect(() => TrailTabEventsBloc(databaseMock, null, locationServiceMock),
          throwsA(anything));
    });

    test("Location Service cannot be null", () {
      expect(() => TrailTabEventsBloc(databaseMock, eventFilterMockAll, null),
          throwsA(anything));
    });

    test("Initializes", () {
      var bloc = TrailTabEventsBloc(databaseMock, eventFilterMockAll, locationServiceMock);
      expect(bloc.lastLocation, Point(33.5275743, -86.7651301));
      expect(bloc.filteredTrailEvents.length, 3);
    });
  });

}

/// Note: DateTime.now is notoriously impossible to mock. See https://github.com/dart-lang/sdk/issues/28985
/// 
/// Instead of implementing the ugly workarounds, we're utilizing extremes. Events 
/// are set in the far future, unless we want them to be in the past.
class TestDataEvents {
  static List<TrailEvent> events = [
    TrailEvent.create(
      allDayEvent: false,
      color: "0xff206177",
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
    TrailEvent.create(
      allDayEvent: false,
      color: "0xff206177",
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
    TrailEvent.create(
      allDayEvent: false,
      color: "0xff206177",
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