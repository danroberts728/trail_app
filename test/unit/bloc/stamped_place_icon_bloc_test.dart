// Copyright (c) 2020, Fermented Software.
import 'package:beer_trail_app/blocs/stamped_place_icon_bloc.dart';
import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;

void main() {
  group("getShortText tests", () {
    flutter_test.TestWidgetsFlutterBinding.ensureInitialized();

    test("Greater than limit", () {
      expect(
      StampedPlaceIconBloc.getShortText("Interstellar Ginger Beer & Exploration Co", 25), 
      "Interstellar Ginger Beer");
    });

    test("Don't cut off words", () {
      expect(
      StampedPlaceIconBloc.getShortText("Interstellar Ginger Beer & Exploration Co", 16), 
      "Interstellar");
    });

    test("Leave if below limit", () {
      expect(
      StampedPlaceIconBloc.getShortText("Cahaba Brewing Co", 100), 
      "Cahaba Brewing Co");
    });

    test("Use ellipis if required", () {
      expect(
        StampedPlaceIconBloc.getShortText("abcdefghijklmnopqrstuvwyz", 5),
        'ab...'
      );
    });

    test("Don't end with 'and'", () {
      expect(
        StampedPlaceIconBloc.getShortText("Interstellar Ginger Beer and Exploration Co", 35),
        "Interstellar Ginger Beer"
      );
    });

    test("Don't end with '&'", () {
      expect(
        StampedPlaceIconBloc.getShortText("Interstellar Ginger Beer & Exploration Co", 35),
        "Interstellar Ginger Beer"
      );
    });

  });
}