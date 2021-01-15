import 'dart:math';

import 'package:alabama_beer_trail/blocs/tabscreen_trail_events_bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/util/event_filter.dart';
import 'package:alabama_beer_trail/util/location_service.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;

import '../test_data/test_data_events.dart';

class TrailDatabaseMock extends Mock implements TrailDatabase {}
class LocationServiceMock extends Mock implements LocationService {}
class EventFilterMock extends Mock implements EventFilter {}
class StreamMock<T> extends Mock implements Stream<T> {}

void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();
  TrailDatabaseMock databaseMock = TrailDatabaseMock();
  LocationServiceMock locationServiceMock = LocationServiceMock();
  EventFilterMock eventFilterMock5 = EventFilterMock();
  EventFilterMock eventFilterMock25 = EventFilterMock();
  EventFilterMock eventFilterMock50 = EventFilterMock();
  EventFilterMock eventFilterMock100 = EventFilterMock();
  EventFilterMock eventFilterMockAll = EventFilterMock();


  setUp(() {
    when(databaseMock.events).thenReturn(TestDataEvents.events);
    when(databaseMock.eventsStream).thenAnswer((_) => StreamMock());

    when(locationServiceMock.lastLocation).thenAnswer((_) => Point(33.5275743, -86.7651301)); // Cahaba Location
    when(locationServiceMock.locationStream).thenAnswer((_) => StreamMock());

    when(eventFilterMock5.distance).thenReturn(5.0);
    when(eventFilterMock25.distance).thenReturn(25.0);
    when(eventFilterMock50.distance).thenReturn(50.0);
    when(eventFilterMock100.distance).thenReturn(100.0);
    when(eventFilterMockAll.distance).thenReturn(double.infinity);
    when(eventFilterMock5.stream).thenAnswer((_) => StreamMock());
    when(eventFilterMock25.stream).thenAnswer((_) => StreamMock());
    when(eventFilterMock50.stream).thenAnswer((_) => StreamMock());
    when(eventFilterMock100.stream).thenAnswer((_) => StreamMock());
    when(eventFilterMockAll.stream).thenAnswer((_) => StreamMock());
  });

  group("Constructor tests", () {
    test("DB cannot be null", () {
      expect(() => TabScreenTrailEventsBloc(null, eventFilterMockAll, locationServiceMock),
          throwsA(anything));
    });

    test("Filter cannot be null", () {
      expect(() => TabScreenTrailEventsBloc(databaseMock, null, locationServiceMock),
          throwsA(anything));
    });

    test("Location Service cannot be null", () {
      expect(() => TabScreenTrailEventsBloc(databaseMock, eventFilterMockAll, null),
          throwsA(anything));
    });

    test("Initializes", () {
      var bloc = TabScreenTrailEventsBloc(databaseMock, eventFilterMockAll, locationServiceMock);
      expect(bloc.lastLocation, Point(33.5275743, -86.7651301));
      expect(bloc.filteredTrailEvents.length, 3);
    });
  });

}