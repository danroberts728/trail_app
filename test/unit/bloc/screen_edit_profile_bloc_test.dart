import 'package:alabama_beer_trail/blocs/screen_edit_profile_bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;

import '../test_data/test_data_user_data.dart';

class TrailDatabaseMock extends Mock implements TrailDatabase {}
class StreamMock<T> extends Mock implements Stream<T> {}

void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();

  TrailDatabaseMock databaseMock = TrailDatabaseMock();  
  tearDown(resetMockitoState);

  setUp(() {
    when(databaseMock.userData).thenReturn(TestDataUserData.userData);
    when(databaseMock.userDataStream).thenAnswer((_) => StreamMock());
  });

  group('Constructor tests', () {
    test("Database cannot be null", () {
      expect(() => ScreenEditProfileBloc(null),
          throwsA(anything));
    });
  });

  group('Update DOB tests', () {
    test('null returns nothing', () {
      var bloc = ScreenEditProfileBloc(databaseMock);
      bloc.updateDisplayName(null);
    });

    test('Empty string returns nothing', () {
      var bloc = ScreenEditProfileBloc(databaseMock);
      bloc.updateDisplayName("");
    });
  });
}