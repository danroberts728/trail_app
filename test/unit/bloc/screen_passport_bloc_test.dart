import 'package:alabama_beer_trail/blocs/screen_passport_bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;

import '../test_data/test_data_checkins.dart';
import '../test_data/test_data_places.dart';

class TrailDatabaseMock extends Mock implements TrailDatabase {}
class StreamMock<T> extends Mock implements Stream<T> {}

void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();

  TrailDatabaseMock databaseMock = TrailDatabaseMock();  
  tearDown(resetMockitoState);

  setUp(() {
    when(databaseMock.places).thenReturn(TestDataPlaces.places);
    when(databaseMock.placesStream).thenAnswer((_) => StreamMock());
    when(databaseMock.checkIns).thenReturn(TestDataCheckIns.checkIns);
    when(databaseMock.checkInStream).thenAnswer((_) => StreamMock());
  });

  group('Constructor tests', () {
    test("Database cannot be null", () {
      expect(() => ScreenPassportBloc(null),
          throwsA(anything));
    });

    test("Constructor populates data", () {
      var bloc = ScreenPassportBloc(databaseMock);
      expect(bloc.stampInformation == null, false);
    });
  });
}