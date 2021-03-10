// Copyright (c) 2020, Fermented Software.
import 'package:beer_trail_app/blocs/trailplace_on_tap_bloc.dart';
import 'package:trail_database/trail_database.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;

class TrailDatabaseMock extends Mock implements TrailDatabase {}
class StreamMock<T> extends Mock implements Stream<T> {}

void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();
  TrailDatabaseMock databaseMock = TrailDatabaseMock();

  group("Constructor tests", () {
    test("placeId cannot be null", () {
      expect(() => TrailPlaceOnTapBloc(null, databaseMock),
          throwsA(anything));
    });

    test("Database cannot be null", () {
      expect(() => TrailPlaceOnTapBloc('dummy', null),
          throwsA(anything));
    });
  });
}