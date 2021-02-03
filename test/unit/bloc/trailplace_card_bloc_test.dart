// Copyright (c) 2020, Fermented Software.
import 'package:beer_trail_app/blocs/trailplace_card_bloc.dart';
import 'package:beer_trail_app/data/trail_database.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;

import '../test_data/test_data_checkins.dart';
import '../test_data/test_data_places.dart';

class TrailDatabaseMock extends Mock implements TrailDatabase {}

class StreamMock<T> extends Mock implements Stream<T> {}

void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();
  TrailDatabaseMock databaseMock = TrailDatabaseMock();

  setUp(() {
    when(databaseMock.checkIns).thenReturn(TestDataCheckIns.checkIns);
    when(databaseMock.checkInStream).thenAnswer((_) => StreamMock());
    when(databaseMock.places).thenReturn(TestDataPlaces.places);
    when(databaseMock.placesStream).thenAnswer((_) => StreamMock());
  });

  group("Constructor tests", () {
    test("Database cannot be null", () {
      expect(() => TrailPlaceCardBloc(null, 'avondale'), throwsA(anything));
    });

    test("PlaceId cannot be null", () {
      expect(() => TrailPlaceCardBloc(databaseMock, null), throwsA(anything));
    });

    test("Check ins count is always populated on construction", () {
      var bloc = TrailPlaceCardBloc(databaseMock, 'dummy');
      expect(bloc.checkInsCount, 0);
    });

    test("Check ins count is populated on construction", () {
      var bloc = TrailPlaceCardBloc(databaseMock, 'avondale');
      expect(bloc.checkInsCount, 2);
    });
  });

  group("getFirstCheckIn tests", () {
    test("Get first check in", () {
      var bloc = TrailPlaceCardBloc(databaseMock, 'avondale');
      expect(bloc.getFirstCheckIn(), DateTime(2020, 8, 17));

      bloc = TrailPlaceCardBloc(databaseMock, 'cahaba');
      expect(bloc.getFirstCheckIn(), DateTime(2020, 8, 16));
    });

    test("Return null if no check ins", () {
      var bloc = TrailPlaceCardBloc(databaseMock, 'dont-exist');
      expect(bloc.getFirstCheckIn(), null);
    });
  });
}
