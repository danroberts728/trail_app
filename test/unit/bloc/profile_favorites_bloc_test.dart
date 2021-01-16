// Copyright (c) 2020, Fermented Software.
import 'package:alabama_beer_trail/blocs/profile_favorites_bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/data/user_data.dart';

import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../test_data/test_data_places.dart' as testDataPlaces;
import '../test_data/test_data_user_data.dart' as testDataUserData;

class TrailDatabaseMock extends Mock implements TrailDatabase {}
class StreamMock<T> extends Mock implements Stream<T> {}

List<TrailPlace> testPlaces = testDataPlaces.TestDataPlaces.places;
UserData testUserData = testDataUserData.TestDataUserData.userData;

void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();
  TrailDatabaseMock databaseMock = TrailDatabaseMock();

  setUp(() {
    when(databaseMock.places).thenReturn(testPlaces);
    when(databaseMock.placesStream).thenAnswer((_) => StreamMock());
    when(databaseMock.userData).thenReturn(testUserData);
    when(databaseMock.userDataStream).thenAnswer((_) => StreamMock());
  });

  group("Constructor tests", () {
    test("DB cannot be null", () {
      expect(() => ProfileFavoritesBloc(null), throwsA(anything));
    });
    test("Initialize information", () {
      var bloc = ProfileFavoritesBloc(databaseMock);
      var favorites = bloc.favorites;
      expect(favorites.length, 2);
      for (int i = 0; i < favorites.length; i++) {
        expect(testUserData.favorites.contains(favorites[i].id), true);
      }
    });
  });
}