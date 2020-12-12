// Copyright (c) 2020, Fermented Software.
import 'package:alabama_beer_trail/blocs/app_drawer_stats_bloc.dart';
import 'package:test/test.dart';

void main() {
  group("Constructor tests", () {
    test("Database cannot be null", () {
      expect(() => AppDrawerStatsBloc(null), throwsA(anything));
    });
  });
}
