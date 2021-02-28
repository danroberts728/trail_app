// Copyright (c) 2020, Fermented Software.
import 'package:beer_trail_app/blocs/trail_activity_log_bloc.dart';
import 'package:beer_trail_database/trail_database.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;

import '../test_data/test_data_checkins.dart';
import '../test_data/test_data_places.dart';
import '../test_data/test_data_user_data.dart';

class TrailDatabaseMock extends Mock implements TrailDatabase {}

class StreamMock<T> extends Mock implements Stream<T> {}

void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();
  TrailDatabaseMock databaseMock = TrailDatabaseMock();

  setUp(() {
    when(databaseMock.checkIns).thenReturn(TestDataCheckIns.checkIns);
    when(databaseMock.checkInStream).thenAnswer((_) => StreamMock());
    when(databaseMock.userData).thenReturn(TestDataUserData.userData);
    when(databaseMock.userDataStream).thenAnswer((_) => StreamMock());
    when(databaseMock.places).thenReturn(TestDataPlaces.places);
    when(databaseMock.placesStream).thenAnswer((_) => StreamMock());
  });

  group("Constructor tests", () {
    test("DB cannot be null", () {
      expect(() => TrailActivityLogBloc(null, 5), throwsA(anything));
    });

    test("Limit must be positive integer", () {
      expect(() => TrailActivityLogBloc(databaseMock, -5), throwsA(anything));
      expect(() => TrailActivityLogBloc(databaseMock, 0), throwsA(anything));
      TrailActivityLogBloc(databaseMock, 1);
    });

    test("Initializes data", () {
      var bloc = TrailActivityLogBloc(databaseMock, 5);
      expect(bloc.activities.length, 2);
    });
  });
}
