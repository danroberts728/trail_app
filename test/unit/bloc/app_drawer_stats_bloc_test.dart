// Copyright (c) 2020, Fermented Software.
import 'package:beer_trail_app/bloc/app_drawer_stats_bloc.dart';
import 'package:trail_database/domain/check_in.dart';
import 'package:trail_database/trail_database.dart';
import 'package:trail_database/domain/trail_place.dart';
import 'package:trail_database/domain/user_data.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../test_data/test_data_places.dart' as testPlaces;
import '../test_data/test_data_checkins.dart' as testCheckins;
import '../test_data/test_data_user_data.dart' as testDataUserData;

class TrailDatabaseMock extends Mock implements TrailDatabase {}
class StreamMock<T> extends Mock implements Stream<T> {}

List<TrailPlace> testPlacesData = testPlaces.TestDataPlaces.places;
List<CheckIn> testCheckInData = testCheckins.TestDataCheckIns.checkIns;
UserData testUserData = testDataUserData.TestDataUserData.userData;

void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();
  TrailDatabaseMock databaseMock = TrailDatabaseMock();

  setUp(() {
    when(databaseMock.places).thenReturn(testPlacesData);
    when(databaseMock.placesStream).thenAnswer((_) => StreamMock());
    when(databaseMock.checkIns).thenReturn(testCheckInData);
    when(databaseMock.checkInStream).thenAnswer((_) => StreamMock());
    when(databaseMock.userData).thenReturn(testUserData);
    when(databaseMock.userDataStream).thenAnswer((_) => StreamMock());
  });

  group("Constructor tests", () {
    test("DB cannot be null", () {
      expect(() => AppDrawerStatsBloc(null), throwsA(anything));
    });
    test("Initialize information", () {
      var bloc = AppDrawerStatsBloc(databaseMock);
      var initialPlaceInformation = bloc.userPlacesInformation;
      expect(initialPlaceInformation.length, testPlacesData.length);
      for (int i = 0; i < testPlacesData.length; i++) {
        var place = initialPlaceInformation[i].place;
        expect(place.id, testPlacesData[i].id);
        expect(initialPlaceInformation[i].isUserFavorite,
            testUserData.favorites.contains(place.id));
        expect(initialPlaceInformation[i].userHasCheckedIn,
            testCheckInData.any((c) => c.placeId == place.id));
      }
    });
  });
}
