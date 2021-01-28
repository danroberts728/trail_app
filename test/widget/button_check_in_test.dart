import 'dart:math';

import 'package:alabama_beer_trail/blocs/button_check_in_bloc.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/data/trail_trophy.dart';
import 'package:alabama_beer_trail/model/app_user.dart';
import 'package:alabama_beer_trail/model/check_in.dart';
import 'package:alabama_beer_trail/util/appauth.dart';
import 'package:alabama_beer_trail/widgets/button_check_in.dart';
import 'package:alabama_beer_trail/widgets/location_off_dialog.dart';
import 'package:alabama_beer_trail/widgets/must_check_in_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class ButtonCheckInBlocMock extends Mock implements ButtonCheckInBloc {}

class AppAuthMock extends Mock implements AppAuth {}

class TrailPlaceMock extends Mock implements TrailPlace {}

class StreamMock<T> extends Mock implements Stream<T> {}

void main() {
  ButtonCheckInBlocMock mockBloc = ButtonCheckInBlocMock();
  TrailPlaceMock mockPlace = TrailPlaceMock();
  AppAuthMock mockAuth = AppAuthMock();
  AppUser mockUser = AppUser(
    uid: 'mock',
    createdDate: 'mockdate',
    email: 'test@gmail.com',
    isAnonymous: false,
  );

  setUp(() {
    // Default mock results
    when(mockPlace.id).thenReturn('mock-id');
    when(mockPlace.name).thenReturn('Mock Brewing Co');
    when(mockPlace.location).thenReturn(Point(1, 1));
    when(mockBloc.isCloseEnoughToCheckIn(Point(1, 1))).thenAnswer((_) => true);
    when(mockBloc.isLocationOn()).thenAnswer((_) => true);
    when(mockBloc.checkIns).thenAnswer((_) => List<CheckIn>());
    when(mockBloc.isCheckedInToday('mock-id')).thenAnswer((_) => true);
    when(mockBloc.stream).thenAnswer((_) => StreamMock<List<CheckIn>>());
    when(mockBloc.isCheckedInToday('mock-id')).thenAnswer((_) => false);
    when(mockBloc.isStamped('mock-id')).thenAnswer((_) => false);
    when(mockBloc.checkIn('mock-id')).thenAnswer((_) =>
        Future.delayed(Duration(microseconds: 10), () => <TrailTrophy>[]));
    when(mockAuth.user).thenReturn(mockUser);
  });

  group("Assertion tests", () {
    test("BLoC cannot be null", () {
      expect(
          () => CheckinButton(bloc: null, place: mockPlace, appAuth: mockAuth),
          throwsA(anything));
    });
    test("Place cannot be null", () {
      expect(
          () => CheckinButton(
              bloc: ButtonCheckInBlocMock(), place: null, appAuth: mockAuth),
          throwsA(anything));
    });

    test("Auth cannot be null", () {
      expect(
          () => CheckinButton(
              bloc: ButtonCheckInBlocMock(), place: mockPlace, appAuth: null),
          throwsA(anything));
    });
  });

  group("showAlways Tests", () {
    testWidgets("showAlways = true, show when in range",
        (WidgetTester tester) async {
      when(mockBloc.isCloseEnoughToCheckIn(Point(1, 1)))
          .thenAnswer((_) => true);
      MaterialApp testCheckInButton = MaterialApp(
        home: Scaffold(
          body: CheckinButton(
            bloc: mockBloc,
            appAuth: mockAuth,
            place: mockPlace,
            showAlways: true,
          ),
        ),
      );

      await tester.pumpWidget(testCheckInButton);
      final theButton = find.text("STAMP PASSPORT");
      expect(theButton, findsOneWidget);
    });

    testWidgets("showAlways = true, show when not in range",
        (WidgetTester tester) async {
      when(mockBloc.isCloseEnoughToCheckIn(Point(1, 1)))
          .thenAnswer((_) => false);
      MaterialApp testCheckInButton = MaterialApp(
        home: Scaffold(
          body: CheckinButton(
            bloc: mockBloc,
            appAuth: mockAuth,
            place: mockPlace,
            showAlways: true,
          ),
        ),
      );

      await tester.pumpWidget(testCheckInButton);
      final theButton = find.text("STAMP PASSPORT");
      expect(theButton, findsOneWidget);
    });

    testWidgets("showAlways = false, show when in range",
        (WidgetTester tester) async {
      when(mockBloc.isCloseEnoughToCheckIn(Point(1, 1)))
          .thenAnswer((_) => true);
      MaterialApp testCheckInButton = MaterialApp(
        home: Scaffold(
          body: CheckinButton(
            bloc: mockBloc,
            appAuth: mockAuth,
            place: mockPlace,
            showAlways: true,
          ),
        ),
      );

      await tester.pumpWidget(testCheckInButton);
      final theButton = find.text("STAMP PASSPORT");
      expect(theButton, findsOneWidget);
    });

    testWidgets("showAlways = false, don't show when not in range",
        (WidgetTester tester) async {
      when(mockBloc.isCloseEnoughToCheckIn(Point(1, 1)))
          .thenAnswer((_) => false);
      MaterialApp testCheckInButton = MaterialApp(
        home: Scaffold(
          body: CheckinButton(
            bloc: mockBloc,
            appAuth: mockAuth,
            place: mockPlace,
            showAlways: false,
          ),
        ),
      );

      await tester.pumpWidget(testCheckInButton);
      final theButton = find.text("STAMP PASSPORT");
      expect(theButton, findsNothing);
    });
  });

  group("Button Text Tests", () {
    testWidgets("Not stamped - show STAMP PASSPORT",
        (WidgetTester tester) async {
      when(mockBloc.isStamped('mock-id')).thenAnswer((realInvocation) => false);
      MaterialApp testCheckInButton = MaterialApp(
        home: Scaffold(
          body: CheckinButton(
            bloc: mockBloc,
            appAuth: mockAuth,
            place: mockPlace,
            showAlways: true,
          ),
        ),
      );

      await tester.pumpWidget(testCheckInButton);
      final theButton = find.text("STAMP PASSPORT");
      expect(theButton, findsOneWidget);
      final theIcon = find.byIcon(Icons.check_box);
      expect(theIcon, findsOneWidget);
    });

    testWidgets("Existing stamp - show CHECK IN", (WidgetTester tester) async {
      when(mockBloc.isStamped('mock-id')).thenAnswer((realInvocation) => true);
      MaterialApp testCheckInButton = MaterialApp(
        home: Scaffold(
          body: CheckinButton(
            bloc: mockBloc,
            appAuth: mockAuth,
            place: mockPlace,
            showAlways: true,
          ),
        ),
      );

      await tester.pumpWidget(testCheckInButton);
      final theButton = find.text("CHECK IN");
      expect(theButton, findsOneWidget);
      final theIcon = find.byIcon(Icons.check_box);
      expect(theIcon, findsOneWidget);
    });

    testWidgets("Existing check in today - show CHECKED IN",
        (WidgetTester tester) async {
      when(mockBloc.isCheckedInToday('mock-id')).thenAnswer((_) => true);
      MaterialApp testCheckInButton = MaterialApp(
        home: Scaffold(
          body: CheckinButton(
            bloc: mockBloc,
            appAuth: mockAuth,
            place: mockPlace,
            showAlways: true,
          ),
        ),
      );

      await tester.pumpWidget(testCheckInButton);
      final theButton = find.text("CHECKED IN");
      expect(theButton, findsOneWidget);
      final theIcon = find.byIcon(Icons.check);
      expect(theIcon, findsOneWidget);
    });
  });

  group("Check in Attempts", () {
    testWidgets("User checked in today already", (WidgetTester tester) async {
      when(mockBloc.isCheckedInToday('mock-id')).thenAnswer((_) => true);
      MaterialApp testCheckInButton = MaterialApp(
        home: Scaffold(
          body: CheckinButton(
            bloc: mockBloc,
            appAuth: mockAuth,
            place: mockPlace,
            showAlways: true,
          ),
        ),
      );

      await tester.pumpWidget(testCheckInButton);
      expect(
          tester
              .widget<RaisedButton>(find.byKey(ValueKey('mock-id-checkin-key')))
              .enabled,
          isFalse);
    });

    testWidgets("User is not logged in", (WidgetTester tester) async {
      when(mockAuth.user).thenReturn(null);
      MaterialApp testCheckInButton = MaterialApp(
        home: Scaffold(
          body: CheckinButton(
            bloc: mockBloc,
            appAuth: mockAuth,
            place: mockPlace,
            showAlways: true,
          ),
        ),
      );
      await tester.pumpWidget(testCheckInButton);
      final theButton = find.byKey(ValueKey('mock-id-checkin-key'));
      expect(theButton, findsOneWidget);
      await tester.tap(theButton);
      await tester.pumpAndSettle();
      final theDialog =
          find.byWidgetPredicate((widget) => widget is MustCheckInDialog);
      expect(theDialog, findsOneWidget);
    });

    testWidgets("User logged in but location off", (WidgetTester tester) async {
      when(mockBloc.isLocationOn()).thenAnswer((_) => false);
      MaterialApp testCheckInButton = MaterialApp(
        home: Scaffold(
          body: CheckinButton(
            bloc: mockBloc,
            appAuth: mockAuth,
            place: mockPlace,
            showAlways: true,
          ),
        ),
      );
      await tester.pumpWidget(testCheckInButton);
      final theButton = find.byKey(ValueKey('mock-id-checkin-key'));
      expect(theButton, findsOneWidget);
      await tester.tap(theButton);
      await tester.pumpAndSettle();
      final theDialog =
          find.byWidgetPredicate((widget) => widget is LocationOffDialog);
      expect(theDialog, findsOneWidget);
    });

    testWidgets("Not close enough", (WidgetTester tester) async {
      when(mockBloc.isCloseEnoughToCheckIn(Point(1, 1)))
          .thenAnswer((_) => false);
      MaterialApp testCheckInButton = MaterialApp(
        home: Scaffold(
          body: CheckinButton(
            bloc: mockBloc,
            appAuth: mockAuth,
            place: mockPlace,
            showAlways: true,
          ),
        ),
      );
      await tester.pumpWidget(testCheckInButton);
      final theButton = find.byKey(ValueKey('mock-id-checkin-key'));
      expect(theButton, findsOneWidget);
      await tester.tap(theButton);
      await tester.pumpAndSettle();
      final theDialog =
          find.text("It looks like you're not at Mock Brewing Co yet. Please try again when you get closer.");
      expect(theDialog, findsOneWidget);
    });

    testWidgets("Able to Check in", (WidgetTester tester) async {
      MaterialApp testCheckInButton = MaterialApp(
        home: Scaffold(
          body: CheckinButton(
            bloc: mockBloc,
            appAuth: mockAuth,
            place: mockPlace,
            showAlways: true,
          ),
        ),
      );
      await tester.pumpWidget(testCheckInButton);
      final theButton = find.byKey(ValueKey('mock-id-checkin-key'));
      expect(theButton, findsOneWidget);
      await tester.tap(theButton);
      await tester.pumpAndSettle();
      final anyDialog = find.byWidgetPredicate((widget) => widget is Dialog);
      expect(anyDialog, findsNothing);
    });
  });
}
