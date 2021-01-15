import 'package:alabama_beer_trail/blocs/tabscreen_trail_list_bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/util/place_filter.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;

import '../test_data/test_data_places.dart';

class TrailDatabaseMock extends Mock implements TrailDatabase {}
class StreamMock<T> extends Mock implements Stream<T> {}
class PlaceFilterMock extends Mock implements PlaceFilter {}

void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();
  TrailDatabaseMock databaseMock = TrailDatabaseMock();
  PlaceFilterMock placeFilterMock = PlaceFilterMock();

  setUp(() {
    when(databaseMock.places).thenReturn(TestDataPlaces.places);
    when(databaseMock.placesStream).thenAnswer((_) => StreamMock());
    when(placeFilterMock.filterCriteria).thenReturn(PlaceFilterCriteria(
      hoursOption: HoursOption.ALL,
      sort: SortOrder.ALPHABETICAL,
    ));
    when(placeFilterMock.stream).thenAnswer((_) => StreamMock());
  });

  group("Constructor tests", () {
    test("Filter cannot be null", () {
      expect(() => TabScreenTrailListBloc(null, databaseMock),
          throwsA(anything));
    });

    test("DB cannot be null", () {
      expect(() => TabScreenTrailListBloc(placeFilterMock, null),
          throwsA(anything));
    });

    test("Initializes", () {
      var bloc = TabScreenTrailListBloc(placeFilterMock, databaseMock);
      expect(bloc.allTrailPlaces.length, 2);
    });
  });
}