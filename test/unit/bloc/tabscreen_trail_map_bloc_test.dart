// Copyright (c) 2020, Fermented Software.
import 'package:beer_trail_app/data/trail_database.dart';
import 'package:beer_trail_app/blocs/tabscreen_trail_map_bloc.dart';

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;

import '../test_data/test_data_places.dart';

class TrailDatabaseMock extends Mock implements TrailDatabase {}

class StreamMock<T> extends Mock implements Stream<T> {}

void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();
  TrailDatabaseMock databaseMock = TrailDatabaseMock();

  when(databaseMock.places).thenReturn(TestDataPlaces.places);
  when(databaseMock.placesStream).thenAnswer((_) => StreamMock());

  group("Constructor tests", () {
    test("DB cannot be null", () {
      expect(() => TabScreenTrailMapBloc(null), throwsA(anything));
    });

    test("Initilizes data", () {
      var bloc = TabScreenTrailMapBloc(databaseMock);
      expect(bloc.allTrailPlaces.length, 3);
    });
  });
}
