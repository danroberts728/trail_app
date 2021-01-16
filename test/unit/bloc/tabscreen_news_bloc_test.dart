// Copyright (c) 2020, Fermented Software.
import 'package:alabama_beer_trail/blocs/tabscreen_news_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Constructor Tests", () {
    test("feed cannot be null", () {
      expect(() => TabScreenNewsBloc(null),
          throwsA(anything));
    });
  });
}