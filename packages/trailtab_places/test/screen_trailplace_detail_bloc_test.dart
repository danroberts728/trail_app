// Copyright (c) 2020, Fermented Software.
import 'package:trailtab_places/bloc/screen_trailplace_detail_bloc.dart';
import 'package:trail_database/trail_database.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:fake_async/fake_async.dart';

import './test_data/test_data_all_beers.dart';
import './test_data/test_data_checkins.dart';
import './test_data/test_data_events.dart';
import './test_data/test_data_places.dart';
import './test_data/test_data_taps.dart';

class TrailDatabaseMock extends Mock implements TrailDatabase {}
class StreamMock<T> extends Mock implements Stream<T> {}

/// Test for the Tab Selection Service utility class
void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();
  TrailDatabaseMock databaseMock = TrailDatabaseMock();
  

  tearDown(resetMockitoState);

  setUp(() {
    when(databaseMock.places).thenReturn(TestDataPlaces.places);
    when(databaseMock.placesStream).thenAnswer((_) => StreamMock());
    when(databaseMock.checkIns).thenReturn(TestDataCheckIns.checkIns);
    when(databaseMock.checkInStream).thenAnswer((_) => StreamMock());
    when(databaseMock.events).thenReturn(TestDataEvents.events);
    when(databaseMock.eventsStream).thenAnswer((_) => StreamMock());
    when(databaseMock.getTaps('sta')).thenAnswer((_) => Future.microtask(() => TestDataTaps.getTaps('sta')));
    when(databaseMock.getPopularBeers('sta')).thenAnswer((_) => Future.microtask(() => TestDataAllBeers.getPopularBeers('sta')));
  });

  group('Constructor', () {
    test('placeId cannot be null', () {
      expect(() => ScreenTrailPlaceDetailBloc(null, databaseMock),
          throwsA(anything));
    });

    test('Database cannot be null', () {
      expect(() => ScreenTrailPlaceDetailBloc('avondale', null),
          throwsA(anything));
    });
  });

  group('Initial Data', () {

    test('Place is set', () {
      var bloc = ScreenTrailPlaceDetailBloc('sta', databaseMock);
      expectLater(bloc.placeDetail.place.id, 'sta');
    });

    test('Check Ins Count is correct', () {
      var bloc = ScreenTrailPlaceDetailBloc('sta', databaseMock);
      expectLater(bloc.placeDetail.checkInsCount, 1);
    });

    test('Events are set', () {
      fakeAsync((async) {
        var bloc = ScreenTrailPlaceDetailBloc('sta', databaseMock);
        expectLater(bloc.placeDetail.events.length, 1);
        expectLater(bloc.placeDetail.events.first.id, '19304');
      });
    });
  });
}
