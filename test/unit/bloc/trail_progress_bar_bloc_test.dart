// Copyright (c) 2020, Fermented Software.
import 'package:beer_trail_app/blocs/trail_progress_bar_bloc.dart';
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
    test("DB cannot be null", () {
      expect(() => TrailProgressBarBloc(null), throwsA(anything));
    });

    test("Initializes data", () {
      var bloc = TrailProgressBarBloc(databaseMock);
      expect(bloc.progressInformation != null, true);
    });
  });

  group("Data validation", () {
    test("total places", () {
      var bloc = TrailProgressBarBloc(databaseMock);
      expect(bloc.progressInformation.totalPlaces, 3);
    });

    test("unique CheckIns", () {
      var bloc = TrailProgressBarBloc(databaseMock);
      expect(bloc.progressInformation.uniqueCheckIns, 2);
    });

    test("percent progress", () {
      var bloc = TrailProgressBarBloc(databaseMock);
      expect(bloc.progressInformation.percentProgress, 2/3);
    });
  });
}
