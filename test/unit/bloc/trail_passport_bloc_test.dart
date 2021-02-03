// Copyright (c) 2020, Fermented Software.
import 'package:beer_trail_app/blocs/trail_passport_bloc.dart';
import 'package:beer_trail_app/data/trail_database.dart';
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

  setUp(() {
    when(databaseMock.checkIns).thenReturn(TestDataCheckIns.checkIns);
    when(databaseMock.checkInStream).thenAnswer((_) => StreamMock());
    when(databaseMock.places).thenReturn(TestDataPlaces.places);
    when(databaseMock.placesStream).thenAnswer((_) => StreamMock());
  });

  group("Constructor tests", () {
    test("DB cannot be null", () {
      expect(() => TrailPassportBloc(null), throwsA(anything));
    });

    test("Initializes data", () {
      var bloc = TrailPassportBloc(databaseMock);
      expect(bloc.stampInformation.length, 3);
    });
  });

  group("Data accuracy", () {
    test("Earliest check in date for stamp", () {
      var bloc = TrailPassportBloc(databaseMock);
      var cahabaStamp = bloc.stampInformation.firstWhere((s) => s.place.id == 'cahaba');
      expect(cahabaStamp.stampDate.year, 2020);
      expect(cahabaStamp.stampDate.month, 8);
      expect(cahabaStamp.stampDate.day, 16);
    });

    test("isStamped test", () {
      var bloc = TrailPassportBloc(databaseMock);
      var braidedRiverStamp = bloc.stampInformation.firstWhere((s) => s.place.id == 'braided-river');
      expect(braidedRiverStamp.isStamped, false);

      var cahabaStamp = bloc.stampInformation.firstWhere((s) => s.place.id == 'cahaba');
      expect(cahabaStamp.isStamped, true);
    });

    test("checkInCount test", () {
      var bloc = TrailPassportBloc(databaseMock);
      var staStamp = bloc.stampInformation.firstWhere((s) => s.place.id == 'sta');
      expect(staStamp.checkInCount, 1);

      var cahabaStamp = bloc.stampInformation.firstWhere((s) => s.place.id == 'cahaba');
      expect(cahabaStamp.checkInCount, 2);
    });
  });
}
