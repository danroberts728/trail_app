// Copyright (c) 2020, Fermented Software.
import 'dart:async';
import 'dart:math';
import 'package:alabama_beer_trail/util/location_service.dart';
import 'package:mockito/mockito.dart';

import 'package:alabama_beer_trail/util/geo_methods.dart';
import 'package:alabama_beer_trail/util/tabselection_service.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:test/test.dart';

import 'package:alabama_beer_trail/util/event_filter.dart';

class LocationServiceMock extends Mock
  implements LocationService {}

/// Tests for utlity methods found in the util folder
void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();

  LocationServiceMock locationServiceMock = LocationServiceMock();  

  tearDown(resetMockitoState);
  
  group('Event Filter', () {
    test('default distance with no location', () {
      when(locationServiceMock.lastLocation).thenReturn(null);
      when(locationServiceMock.refreshLocation()).thenAnswer(null);
      EventFilter eventFilter = EventFilter(locationService: locationServiceMock);
      expect(eventFilter.distance, double.infinity);
    });

    test('default distance with location', () {
      when(locationServiceMock.lastLocation).thenReturn(Point(35.4, -86.5));
      EventFilter eventFilter = EventFilter(locationService: locationServiceMock);
      expect(eventFilter.distance, 50.0);
    });

    test('broadcast stream', () {
      when(locationServiceMock.lastLocation).thenReturn(Point(35.4, -86.5));
      EventFilter eventFilter = EventFilter(locationService: locationServiceMock);
      eventFilter.stream.listen((a) => null);
      expect(eventFilter.stream.listen((a) => null),
          isA<StreamSubscription<EventFilter>>());
    });

    test('Less than 0', () {
      when(locationServiceMock.lastLocation).thenReturn(Point(35.4, -86.5));
      EventFilter eventFilter = EventFilter(locationService: locationServiceMock);
      eventFilter.updateFilter(distance: -2);
      expect(eventFilter.distance, equals(0));
    });

    test('Normal update', () {
      when(locationServiceMock.lastLocation).thenReturn(Point(35.4, -86.5));
      EventFilter eventFilter = EventFilter(locationService: locationServiceMock);
      eventFilter.updateFilter(distance: 25);
      expect(eventFilter.distance, equals(25));
    });

    test('Stream', () {
      when(locationServiceMock.lastLocation).thenReturn(Point(35.4, -86.5));
      EventFilter eventFilter = EventFilter(locationService: locationServiceMock);
      eventFilter.stream.listen((event) {
        expect(event.distance, 500.2);
      });
      eventFilter.updateFilter(distance: 500.2);
    });
  });
  group('Geo Methods', () {
    test('Calculate distance between two lat/lng points', () {
      Point a = Point(30.2782023, -87.682762); // Big Beach
      Point b = Point(34.720852, -86.607087); // Straight to Ale
      double answer = GeoMethods.calculateDistance(a, b);
      const double exact = 313.28; // From Google
      expect(answer, closeTo(exact, 0.5)); // Half mile tolerance.
    });

    test('Null point1', () {
      Point b = Point(34.720852, -86.607087); // Straight to Ale
      double answer = GeoMethods.calculateDistance(null, b);
      expect(answer, null);
    });

    test('Null point2', () {
      Point a = Point(34.720852, -86.607087); // Straight to Ale
      double answer = GeoMethods.calculateDistance(a, null);
      expect(answer, null);
    });

    test('Null distance', () {
      String answer = GeoMethods.toFriendlyDistanceString(null);
      expect(answer, '');
    });

    test('Less than minDistance', () {
      String answer = GeoMethods.toFriendlyDistanceString(
          TrailAppSettings.minDistanceToCheckin - 0.00001);
      expect(answer, '0');
    });

    test('Less than 1', () {
      String answer = GeoMethods.toFriendlyDistanceString(1 - 0.01);
      expect(answer, '0.99');
    });

    test('Less than 10', () {
      String answer = GeoMethods.toFriendlyDistanceString(10 - 0.05);
      expect(answer, '9.9');
    });

    test('Greater than 10', () {
      String answer = GeoMethods.toFriendlyDistanceString(10 + 0.01);
      expect(answer, '10');
    });

    test('Much greater than 10', () {
      String answer = GeoMethods.toFriendlyDistanceString(10567 + 0.01);
      expect(answer, '10,567');
    });
  });
  group('Tab selection', () {
    test('Update tab', () {
      TabSelectionService _tabService = TabSelectionService();
      _tabService.updateTabSelection(2);
      expect(_tabService.currentSelectedTab, equals(2));
    });
    test('Last tab same', () {
      TabSelectionService _tabService = TabSelectionService();
      _tabService.currentSelectedTab = 3;
      _tabService.updateTabSelection(3);
      expect(_tabService.lastTapSame, equals(true));
    });
    test('Last tab different', () {
      TabSelectionService _tabService = TabSelectionService();
      _tabService.currentSelectedTab = 3;
      _tabService.updateTabSelection(1);
      expect(_tabService.lastTapSame, equals(false));
    });
  });
}