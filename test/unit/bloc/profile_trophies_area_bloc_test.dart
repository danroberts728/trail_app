// Copyright (c) 2020, Fermented Software.
import 'package:alabama_beer_trail/blocs/tabscreen_achievements_bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;

class TrailDatabaseMock extends Mock implements TrailDatabase {}
class StreamMock<T> extends Mock implements Stream<T> {}

void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();

  group("Constructor tests", () {
    test("Database cannot be null", () {
      expect(() => TabScreenAchievementsBloc(null),
          throwsA(anything));
    });
  });
}