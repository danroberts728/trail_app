// Copyright (c) 2020, Fermented Software.
import 'dart:async';
import 'dart:math';
import 'package:mockito/mockito.dart';

import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:test/test.dart';

import 'package:trailtab_events/util/event_filter.dart';
import 'package:trail_location_service/trail_location_service.dart';

class LocationServiceMock extends Mock implements TrailLocationService {}

/// Tests for event filter
void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();

  LocationServiceMock locationServiceMock = LocationServiceMock();

  tearDown(resetMockitoState);

  group('Event Filter', () {
    test('default distance with no location', () {
      when(locationServiceMock.lastLocation).thenReturn(null);
      when(locationServiceMock.refreshLocation()).thenAnswer(null);
      EventFilter eventFilter =
          EventFilter(locationService: locationServiceMock);
      expect(eventFilter.distance, double.infinity);
    });

    test('default distance with location', () {
      when(locationServiceMock.lastLocation).thenReturn(Point(35.4, -86.5));
      EventFilter eventFilter =
          EventFilter(locationService: locationServiceMock);
      expect(eventFilter.distance, 50.0);
    });

    test('broadcast stream', () {
      when(locationServiceMock.lastLocation).thenReturn(Point(35.4, -86.5));
      EventFilter eventFilter =
          EventFilter(locationService: locationServiceMock);
      eventFilter.stream.listen((a) => null);
      expect(eventFilter.stream.listen((a) => null),
          isA<StreamSubscription<EventFilter>>());
    });

    test('Less than 0', () {
      when(locationServiceMock.lastLocation).thenReturn(Point(35.4, -86.5));
      EventFilter eventFilter =
          EventFilter(locationService: locationServiceMock);
      eventFilter.updateFilter(distance: -2);
      expect(eventFilter.distance, equals(0));
    });

    test('Normal update', () {
      when(locationServiceMock.lastLocation).thenReturn(Point(35.4, -86.5));
      EventFilter eventFilter =
          EventFilter(locationService: locationServiceMock);
      eventFilter.updateFilter(distance: 25);
      expect(eventFilter.distance, equals(25));
    });

    test('Stream', () {
      when(locationServiceMock.lastLocation).thenReturn(Point(35.4, -86.5));
      EventFilter eventFilter =
          EventFilter(locationService: locationServiceMock);
      eventFilter.stream.listen((event) {
        expect(event.distance, 500.2);
      });
      eventFilter.updateFilter(distance: 500.2);
    });
  });
}
