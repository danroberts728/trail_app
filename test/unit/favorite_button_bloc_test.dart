// Copyright (c) 2020, Fermented Software.
import 'dart:async';

import 'package:alabama_beer_trail/blocs/favorite_button_bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/user_data.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:test/test.dart';

class TrailDatabaseMock extends Mock implements TrailDatabase {}
class StreamMock<T> extends Mock implements Stream<T> {}

UserData testUserData = UserData(favorites: ['cahaba','sta', 'true-story']);

/// Tests for Favorite Button BLoC
void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();
  TrailDatabaseMock databaseMock = TrailDatabaseMock();  
  tearDown(resetMockitoState);

  setUp(() {
    when(databaseMock.userData).thenReturn(testUserData);
    when(databaseMock.userDataStream).thenAnswer((_) => StreamMock());
  });

  group('Constructor tests', () {
    test('placeId cannot be null', () {
      expect(() => FavoriteButtonBloc(databaseMock, null), throwsA(anything));
    });
    test('DB cannot be null', () {
      expect(() => FavoriteButtonBloc(null, 'avondale'), throwsA(anything));
    });
    test('Already favorite', () {
      var bloc = FavoriteButtonBloc(databaseMock, 'cahaba');
      expect(bloc.isFavorite, true);
    });
    test('Not alraedy a favorite', () {
      var bloc = FavoriteButtonBloc(databaseMock, 'boring-brewery');
      expect(bloc.isFavorite, false);
    });
  });
}