import 'dart:math';

import 'package:alabama_beer_trail/util/location_service.dart';
import 'package:alabama_beer_trail/widgets/location_off_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class LocationServiceMock extends Mock implements LocationService {}

class StreamMock<T> extends Mock implements Stream<T> {}

void main() {
  LocationServiceMock locationServiceMock = LocationServiceMock();

  setUp(() {
    // Default mock results
    when(locationServiceMock.lastLocation).thenReturn(Point(1, 2));
    when(locationServiceMock.refreshLocation()).thenAnswer((_) => Future.microtask(() => Point(1,2)));
    when(locationServiceMock.locationStream).thenAnswer((_) => StreamMock());
  });

  group("Location Off Dialog Tests", () {
    testWidgets("Message shows", (tester) async {
      MaterialApp testLocationOffDialog = MaterialApp(
        home: Scaffold(
          body: LocationOffDialog(
            message: "Test Message",
            locationService: locationServiceMock,
          ),
        ),
      );

      await tester.pumpWidget(testLocationOffDialog);
      final theDialog = find.text("Test Message");
      expect(theDialog, findsOneWidget);
    });

    testWidgets("Dismiss", (tester) async {
      MaterialApp testLocationOffDialog = MaterialApp(
        home: Scaffold(
          body: LocationOffDialog(
            message: "Test Message",
            locationService: locationServiceMock,
          ),
        ),
      );

      await tester.pumpWidget(testLocationOffDialog);
      var theDialog = find.text("Test Message");
      expect(theDialog, findsOneWidget);
      final theDismissButton = find.text("Dismiss");
      expect(theDismissButton, findsOneWidget);
      await tester.tap(theDismissButton);
      await tester.pumpAndSettle();
      theDialog = find.text("Test Message");
      expect(theDialog, findsNothing);
    });

    testWidgets("Allow Location but then deny", (tester) async {
      when(locationServiceMock.refreshLocation()).thenAnswer((_) => Future.microtask(() => null));
      MaterialApp testLocationOffDialog = MaterialApp(
        home: Scaffold(
          body: LocationOffDialog(
            message: "Test Message",
            locationService: locationServiceMock,
          ),
        ),
      );

      await tester.pumpWidget(testLocationOffDialog);
      var theDialog = find.text("Test Message");
      expect(theDialog, findsOneWidget);
      final theAllowLocationButton = find.text("Allow Location");
      expect(theAllowLocationButton, findsOneWidget);
      await tester.tap(theAllowLocationButton);
      await tester.pumpAndSettle();
      final theNewDialog = find.byKey(ValueKey('unable-to-allow-location-dialog'));
      expect(theNewDialog, findsOneWidget);
      final dismissButton = find.text("Dismiss");
      expect(dismissButton, findsOneWidget);
      await tester.tap(dismissButton);
      await tester.pumpAndSettle();
      final anyDialog = find.byWidgetPredicate((widget) => widget is Dialog);
      expect(anyDialog, findsNothing);
    });

    testWidgets("Allow Location and then allow", (tester) async {
      MaterialApp testLocationOffDialog = MaterialApp(
        home: Scaffold(
          body: LocationOffDialog(
            message: "Test Message",
            locationService: locationServiceMock,
          ),
        ),
      );

      await tester.pumpWidget(testLocationOffDialog);
      var theDialog = find.text("Test Message");
      expect(theDialog, findsOneWidget);
      final theAllowLocationButton = find.text("Allow Location");
      expect(theAllowLocationButton, findsOneWidget);
      await tester.tap(theAllowLocationButton);
      await tester.pumpAndSettle();
      final anyDialog = find.byWidgetPredicate((widget) => widget is Dialog);
      expect(anyDialog, findsNothing);
    });
  });
}