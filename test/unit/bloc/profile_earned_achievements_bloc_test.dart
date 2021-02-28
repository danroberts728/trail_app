// Copyright (c) 2020, Fermented Software.
import 'package:beer_trail_app/blocs/profile_earned_achievements_bloc.dart';
import 'package:trail_database/trail_database.dart';
import 'package:trail_database/domain/trail_trophy.dart';
import 'package:trail_database/domain/user_data.dart';

import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../test_data/test_data_user_data.dart' as testDataUserData;
import '../test_data/test_data_trophies.dart' as testDataTrophies;

class TrailDatabaseMock extends Mock implements TrailDatabase {}
class StreamMock<T> extends Mock implements Stream<T> {}

UserData testUserData = testDataUserData.TestDataUserData.userData;
List<TrailTrophy> testTrophyData = testDataTrophies.TestDataTrophies.trophies;

void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();
  TrailDatabaseMock databaseMock = TrailDatabaseMock();

  setUp(() {
    when(databaseMock.trophies).thenReturn(testTrophyData);
    when(databaseMock.trophiesStream).thenAnswer((_) => StreamMock());
    when(databaseMock.userData).thenReturn(testUserData);
    when(databaseMock.userDataStream).thenAnswer((_) => StreamMock());
  });

  group("Constructor tests", () {
    test("DB cannot be null", () {
      expect(() => ProfileEarnedAchievementsBloc(null), throwsA(anything));
    });
    test("Initialize information", () {
      var bloc = ProfileEarnedAchievementsBloc(databaseMock);
      var trophiesEarned = bloc.userEarnedTrophies;
      expect(trophiesEarned.length, testUserData.trophies.length);
      for (int i = 0; i < trophiesEarned.length; i++) {
        expect(testUserData.trophies.containsKey(trophiesEarned[i].id), true);
      }
    });
  });
}