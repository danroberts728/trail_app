// Copyright (c) 2020, Fermented Software.
import 'package:beer_trail_app/blocs/tabscreen_badges_bloc.dart';
import 'package:beer_trail_database/trail_database.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;

import '../test_data/test_data_trophies.dart';
import '../test_data/test_data_user_data.dart';

class TrailDatabaseMock extends Mock implements TrailDatabase {}
class StreamMock<T> extends Mock implements Stream<T> {}

void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();
  TrailDatabaseMock databaseMock = TrailDatabaseMock();

  setUp(() {
    when(databaseMock.userData).thenReturn(TestDataUserData.userData);
    when(databaseMock.userDataStream).thenAnswer((_) => StreamMock());
    when(databaseMock.trophies).thenReturn(TestDataTrophies.trophies);
    when(databaseMock.trophiesStream).thenAnswer((_) => StreamMock());
  });

  group("Constructor Tests", () {
    test("Database cannot be null", () {
      expect(() => TabScreenBadgesBloc(null),
          throwsA(anything));
    });

    test("userTrophyInformation populated on construction", () {
      var bloc = TabScreenBadgesBloc(databaseMock);
      expect(bloc.userTrophyInformation != null, true);
    });
  });
}