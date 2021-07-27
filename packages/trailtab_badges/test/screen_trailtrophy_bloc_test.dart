// Copyright (c) 2020, Fermented Software.
import 'package:trailtab_badges/bloc/screen_trailtrophy_detail_bloc.dart';
import 'package:trail_database/trail_database.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;

import './test_data/test_data_places.dart';

class TrailDatabaseMock extends Mock implements TrailDatabase {}
class StreamMock<T> extends Mock implements Stream<T> {}

void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();

  TrailDatabaseMock databaseMock = TrailDatabaseMock();  
  tearDown(resetMockitoState);

  setUp(() {
    when(databaseMock.places).thenReturn(TestDataPlaces.places);
    when(databaseMock.placesStream).thenAnswer((_) => StreamMock());
  });

  group('Constructor tests', () {
    test("Database cannot be null", () {
      expect(() => ScreenTrailTrophyDetailBloc(null),
          throwsA(anything));
    });
  });
}