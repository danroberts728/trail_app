// Copyright (c) 2020, Fermented Software.
import 'dart:async';

import 'package:trailtab_places/bloc/button_check_in_bloc.dart';
import 'package:trail_database/domain/check_in.dart';
import 'package:trail_database/trail_database.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:test/test.dart';

import './test_data/test_data_checkins.dart' as testCheckins;

class TrailDatabaseMock extends Mock implements TrailDatabase {}
class StreamMock<T> extends Mock implements Stream<T> {}

List<CheckIn> testCheckinData = testCheckins.TestDataCheckIns.checkIns;

/// Tests for Check in Button BLoC
void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();
  TrailDatabaseMock databaseMock = TrailDatabaseMock();  
  tearDown(resetMockitoState);

  setUp(() {
    when(databaseMock.checkIns).thenReturn(testCheckinData);
    when(databaseMock.checkInStream).thenAnswer((_) => StreamMock());
    when(databaseMock.eventsStream).thenAnswer((_) => StreamMock());
    when(databaseMock.placesStream).thenAnswer((_) => StreamMock());
    when(databaseMock.trophiesStream).thenAnswer((_) => StreamMock());
    when(databaseMock.userDataStream).thenAnswer((_) => StreamMock());
  });

  group('Constructor tests', () {    
    test('DB cannot be null', () {
      expect(() => ButtonCheckInBloc(null), throwsA(anything));
    });
    test('Initialize checkIns', () {
      var bloc = ButtonCheckInBloc(databaseMock);
      var initialCheckIns = bloc.checkIns;
      expect(initialCheckIns.length, testCheckinData.length);
      for(int i = 0; i < initialCheckIns.length; i++) {
        expect(initialCheckIns[i].placeId, testCheckinData[i].placeId);
        expect(initialCheckIns[i].timestamp, testCheckinData[i].timestamp);
      }
    });
  });
  group('isCheckedInToday tests', () {
    test('today is optional', () {
      var bloc = ButtonCheckInBloc(databaseMock);
      expect(bloc.isCheckedInToday('dummy'), false);
    });
    test('Has checked in', () {
      var bloc = ButtonCheckInBloc(databaseMock);
      expect(bloc.isCheckedInToday('avondale', today: DateTime.parse("2020-08-17 19:27:00")),
        true
      );
    });
    test('Has not checked in', () {
      var bloc = ButtonCheckInBloc(databaseMock);
      expect(bloc.isCheckedInToday('sta', today: DateTime.parse("2019-10-22 19:27:00")),
        false
      );
    });
  });

  group("isStamped test", () {
    test('True if 1 check ins', () {
      var bloc = ButtonCheckInBloc(databaseMock);
      expect(bloc.isStamped('cahaba'), true);
    });
    test('True if 2 check ins', () {
      var bloc = ButtonCheckInBloc(databaseMock);
      expect(bloc.isStamped('avondale'), true);
    });
    test('False if 0 check ins', () {
      var bloc = ButtonCheckInBloc(databaseMock);
      expect(bloc.isStamped('doesnt-exist'), false);
    });
  });
}
