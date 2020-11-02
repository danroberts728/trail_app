// Copyright (c) 2020, Fermented Software.
import 'dart:async';

import 'package:alabama_beer_trail/blocs/button_check_in_bloc.dart';
import 'package:alabama_beer_trail/data/check_in.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:test/test.dart';

class TrailDatabaseMock extends Mock implements TrailDatabase {}
class StreamMock<T> extends Mock implements Stream<T> {}

List<CheckIn> testCheckIns = [
  CheckIn('avondale', DateTime.parse("2019-10-12 13:27:00")),
  CheckIn('avondale', DateTime.parse("2019-10-14 18:27:00")),
  CheckIn('avondale', DateTime.parse("2019-10-16 15:27:00")),
  CheckIn('cahaba', DateTime.parse("2019-10-16 16:16:00")),
  CheckIn('true-story', DateTime.parse("2019-10-17 14:16:00")),
  CheckIn('sta', DateTime.parse("2019-12-29 22:11:00")),
];

/// Tests for Check in Button BLoC
void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();
  TrailDatabaseMock databaseMock = TrailDatabaseMock();  
  tearDown(resetMockitoState);

  setUp(() {
    when(databaseMock.checkIns).thenReturn(testCheckIns);
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
      expect(initialCheckIns.length, testCheckIns.length);
      for(int i = 0; i < initialCheckIns.length; i++) {
        expect(initialCheckIns[i].placeId, testCheckIns[i].placeId);
        expect(initialCheckIns[i].timestamp, testCheckIns[i].timestamp);
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
      expect(bloc.isCheckedInToday('avondale', today: DateTime.parse("2019-10-16 19:27:00")),
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
}
