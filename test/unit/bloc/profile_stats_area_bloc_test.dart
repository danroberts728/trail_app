import 'package:alabama_beer_trail/blocs/profile_stats_area_bloc.dart';
import 'package:test/test.dart';

void main() {
  group("Constructor tests", () {
    test("Database cannot be null", () {
      expect(() => ProfileStatsAreaBloc(null), throwsA(anything));
    });
  });
}
