import 'package:alabama_beer_trail/blocs/profile_stats_area_bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class TrailDatabaseMock extends Mock implements TrailDatabase {}

class StreamMock<T> extends Mock implements Stream<T> {}

void main() {
  group("Constructor tests", () {
    test("Database cannot be null", () {
      expect(() => ProfileStatsAreaBloc(null), throwsA(anything));
    });
  });
}
