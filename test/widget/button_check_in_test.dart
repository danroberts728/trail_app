import 'dart:math';

import 'package:alabama_beer_trail/blocs/button_check_in_bloc.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/model/app_user.dart';
import 'package:alabama_beer_trail/model/check_in.dart';
import 'package:alabama_beer_trail/util/appauth.dart';
import 'package:alabama_beer_trail/widgets/button_check_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class ButtonCheckInBlocMock extends Mock implements ButtonCheckInBloc {}

class TrailPlaceMock extends Mock implements TrailPlace {}

class StreamMock<T> extends Mock implements Stream<T> {}

void main() {
  ButtonCheckInBlocMock mockBloc = ButtonCheckInBlocMock();
  TrailPlaceMock mockPlace = TrailPlaceMock();

  setUp(() {
    // Default mock results
    when(mockPlace.id).thenReturn('mock-id');
    when(mockPlace.location).thenReturn(Point(1, 1));
    when(mockBloc.isCloseEnoughToCheckIn(Point(1, 1))).thenAnswer((_) => true);
    when(mockBloc.checkIns).thenAnswer((_) => List<CheckIn>());
    when(mockBloc.isCheckedInToday('mock-id')).thenAnswer((_) => true);
    when(mockBloc.stream).thenAnswer((_) => StreamMock<List<CheckIn>>());
    when(mockBloc.isCheckedInToday('mock-id')).thenAnswer((_) => false);
    when(mockBloc.isStamped('mock-id')).thenAnswer((realInvocation) => false);
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

    /*testWidgets("User is not logged in", (WidgetTester tester) async {
      AppAuth().user = null;
      MaterialApp testCheckInButton = MaterialApp(
        home: Scaffold(
          body: CheckinButton(
            bloc: mockBloc,
            place: mockPlace,
            showAlways: true,
          ),
        ),
      );
      await tester.pumpWidget(testCheckInButton);
      final theButton = find.byWidget(testCheckInButton);
      expect(theButton, findsOneWidget);
      await tester.tap(theButton);
      final theDialog = find.text("You must be signed in to check in.");
      expect(theDialog, findsOneWidget);
    });

    testWidgets("User logged in but location off", (WidgetTester tester) async {
      AppAuth().user = AppUser(
        uid: 'mock',
        createdDate: 'mockdate',
        email: 'test@gmail.com',
        isAnonymous: false,
      );
    });*/
  });
}
