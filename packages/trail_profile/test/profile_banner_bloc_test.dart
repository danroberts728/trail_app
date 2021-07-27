// Copyright (c) 2020, Fermented Software.
import 'package:trail_profile/bloc/profile_banner_bloc.dart';
import 'package:trail_database/trail_database.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:test/test.dart';

import './test_data/test_data_user_data.dart';

class TrailDatabaseMock extends Mock implements TrailDatabase {}
class StreamMock<T> extends Mock implements Stream<T> {}

main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();
  TrailDatabaseMock databaseMock = TrailDatabaseMock();  
  tearDown(resetMockitoState);

  setUp(() {
    when(databaseMock.userData).thenReturn(TestDataUserData.userData);
    when(databaseMock.userDataStream).thenAnswer((_) => StreamMock());
  });

  group('Constructor tests', () {
    test('DB cannot be null', () {
      expect(() => ProfileBannerBloc(null), throwsA(anything));
    });

    test('Banner Image URL is set', () {
      var bloc = ProfileBannerBloc(databaseMock);
      expect(bloc.bannerImageUrl, 'https://freethehops.org/banner.jpg');
    });
  });
}