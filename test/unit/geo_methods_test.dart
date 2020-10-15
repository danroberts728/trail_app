// Copyright (c) 2020, Fermented Software.
import 'dart:math';

import 'package:alabama_beer_trail/util/geo_methods.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:test/test.dart';

void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();
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
}