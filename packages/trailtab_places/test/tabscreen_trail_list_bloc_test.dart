// Copyright (c) 2020, Fermented Software.
import 'dart:math';

import 'package:trailtab_places/bloc/tabscreen_trail_list_bloc.dart';
import 'package:trail_database/trail_database.dart';
import 'package:trail_location_service/trail_location_service.dart';
import 'package:trailtab_places/util/place_filter.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;

import './test_data/test_data_places.dart';

class TrailDatabaseMock extends Mock implements TrailDatabase {}

class StreamMock<T> extends Mock implements Stream<T> {}

class PlaceFilterMock extends Mock implements PlaceFilter {}

class LocationServiceMock extends Mock implements TrailLocationService {}

void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();
  TrailDatabaseMock databaseMock = TrailDatabaseMock();
  PlaceFilterMock placeFilterMock = PlaceFilterMock();
  LocationServiceMock locationServiceMock = LocationServiceMock();

  setUp(() {
    when(databaseMock.places).thenReturn(TestDataPlaces.places);
    when(databaseMock.placesStream).thenAnswer((_) => StreamMock());
    when(placeFilterMock.filterCriteria).thenReturn(PlaceFilterCriteria(
      hoursOption: HoursOption.ALL,
      sort: SortOrder.ALPHABETICAL,
    ));
    when(placeFilterMock.stream).thenAnswer((_) => StreamMock());
    when(placeFilterMock.filterCriteria)
        .thenReturn(PlaceFilterCriteria(sort: SortOrder.ALPHABETICAL));
    when(locationServiceMock.lastLocation)
        .thenReturn(Point(33.5275743, -86.7651301));
    when(locationServiceMock.locationStream).thenAnswer((_) => StreamMock());
  });

  group("Constructor tests", () {
    test("Filter cannot be null", () {
      expect(
          () => TabScreenTrailListBloc(null, databaseMock, locationServiceMock),
          throwsA(anything));
    });

    test("DB cannot be null", () {
      expect(
          () => TabScreenTrailListBloc(
              placeFilterMock, null, locationServiceMock),
          throwsA(anything));
    });

    test("Location service cannot be null", () {
      expect(() => TabScreenTrailListBloc(placeFilterMock, databaseMock, null),
          throwsA(anything));
    });

    test("Initializes", () {
      var bloc = TabScreenTrailListBloc(
          placeFilterMock, databaseMock, locationServiceMock);
      expect(bloc.allTrailPlaces.length, 3);
    });
  });
}
