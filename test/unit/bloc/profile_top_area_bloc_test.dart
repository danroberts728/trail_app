// Copyright (c) 2020, Fermented Software.
import 'package:beer_trail_app/blocs/profile_top_area_bloc.dart';
import 'package:beer_trail_app/data/trail_database.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class TrailDatabaseMock extends Mock implements TrailDatabase {}

class StreamMock<T> extends Mock implements Stream<T> {}

void main() {
  group("Constructor tests", () {
    test("Database cannot be null", () {
      expect(() => ProfileTopAreaBloc(null), throwsA(anything));
    });
  });
}
