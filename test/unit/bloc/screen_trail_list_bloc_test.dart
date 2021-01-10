import 'package:alabama_beer_trail/blocs/screen_trail_list_bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';

import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../test_data/test_data_places.dart' as testDataPlaces;

class TrailDatabaseMock extends Mock implements TrailDatabase {}
class StreamMock<T> extends Mock implements Stream<T> {}

List<TrailPlace> testPlaces = testDataPlaces.TestDataPlaces.places;

void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();
  TrailDatabaseMock databaseMock = TrailDatabaseMock();

  setUp(() {
    when(databaseMock.places).thenReturn(testPlaces);
    when(databaseMock.placesStream).thenAnswer((_) => StreamMock());
  });

  group("Constructor tests", () {
    test("DB cannot be null", () {
      expect(() => ScreenTrailListBloc(null), throwsA(anything));
    });
    test("Initialize information", () {
      var bloc = ScreenTrailListBloc(databaseMock);
      var places = bloc.trailPlaces;
      expect(places.length, testPlaces.length);
      for (int i = 0; i < places.length; i++) {
        expect(places[i].id, testPlaces[i].id);
      }
    });
  });
}