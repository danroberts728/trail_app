// Copyright (c) 2020, Fermented Software.
import 'package:beer_trail_app/blocs/profile_user_photo_bloc.dart';
import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;

void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();
  group('Constructor Tests', () {
    test("Database cannot be null", () {
      expect(() => ProfileUserPhotoBloc(null),
          throwsA(anything));
    });
  });
}