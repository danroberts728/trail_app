// Copyright (c) 2020, Fermented Software.
import 'dart:async';

import 'package:trail_database/domain/beer.dart';
import 'package:trail_database/domain/check_in.dart';
import 'package:trail_database/domain/on_tap_beer.dart';
import 'package:trail_database/trail_database.dart';
import 'package:trail_database/domain/trail_event.dart';
import 'package:trail_database/domain/trail_place.dart';

/// The BLoC for ScreenTrailPlaceDetail objects
class ScreenTrailPlaceDetailBloc {
  /// A reference to the central database
  TrailDatabase _db;

  /// A subscription to all published places
  StreamSubscription _placesSubscription;

  StreamSubscription _eventsSubscription;

  /// A subscription to the user's check ins
  StreamSubscription _checkInsSubscription;

  /// A subscription to the on-tap list for this place
  StreamSubscription _tapSubscription;

  /// A subscription to the all Beers list for this place
  StreamSubscription _allBeersSubscription;

  /// The current place's detail information
  PlaceDetail placeDetail;

  /// The place ID that this BLoC is affiliated with
  String _placeId;

  /// Controller for this BLoC's stream
  final _controller = StreamController<PlaceDetail>();

  /// The stream for the PlaceDetail information
  Stream<PlaceDetail> get stream => _controller.stream;

  /// Default constructor. Each instance of this BLoC is
  /// associated with a single [place].
  ScreenTrailPlaceDetailBloc(String placeId, TrailDatabase db)
      : assert(placeId != null),
        assert(db != null) {
    _placeId = placeId;
    _db = db;

    List<CheckIn> placeCheckIns = _db.checkIns.where((c) => c.placeId == _placeId).toList();
    // Initial data
    placeDetail = PlaceDetail(
      place: _db.places.firstWhere((p) => p.id == _placeId),
      checkInsCount: placeCheckIns.length,
      firstCheckIn: placeCheckIns.length != 0
        ? (placeCheckIns..sort((a,b) => a.timestamp.compareTo(b.timestamp))).first.timestamp
        : DateTime.now(),
      taps: [],
    );
    placeDetail.events = _getPlaceUpcomingEvents(_db.events);

    _placesSubscription = _db.placesStream.listen(_onPlacesUpdate);
    _eventsSubscription = _db.eventsStream.listen(_onEventsUpdate);
    _checkInsSubscription = _db.checkInStream.listen(_onCheckInsUpdate);
    _tapSubscription = _db.getTaps(_placeId).asStream().listen(_onTapUpdate);
    _allBeersSubscription =
        _db.getPopularBeers(_placeId).asStream().listen(_onBeersUpdate);
  }

  List<TrailEvent> _getPlaceUpcomingEvents(List<TrailEvent> allEvents) {
    return allEvents
        .where((e) => e.locationTaxonomy == placeDetail.place.locationTaxonomy)
        .where((e) =>
            e.end.millisecondsSinceEpoch >
            DateTime.now().millisecondsSinceEpoch)
        .toList();
  }

  /// Callback when trail places are updated
  _onPlacesUpdate(List<TrailPlace> event) {
    var newPlace = event.firstWhere((p) => p.id == _placeId);
    placeDetail = PlaceDetail(
      place: newPlace,
      events: placeDetail.events,
      checkInsCount: placeDetail.checkInsCount,
      taps: placeDetail.taps,
      popularBeers: placeDetail.popularBeers,
    );
    _controller.sink.add(placeDetail);
  }

  /// Callback when events are updated
  _onEventsUpdate(List<TrailEvent> event) {
    placeDetail = PlaceDetail(
      place: placeDetail.place,
      events: _getPlaceUpcomingEvents(event),
      checkInsCount: placeDetail.checkInsCount,
      taps: placeDetail.taps,
      popularBeers: placeDetail.popularBeers,
    );
    _controller.sink.add(placeDetail);
  }

  /// Callback when user's check ins are updated
  _onCheckInsUpdate(List<CheckIn> event) {
    var newCheckInsCount = event.where((c) => c.placeId == _placeId).length;
    if (newCheckInsCount != placeDetail.checkInsCount) {
      placeDetail = PlaceDetail(
        place: placeDetail.place,
        events: placeDetail.events,
        checkInsCount: newCheckInsCount,
        firstCheckIn: (event..sort((a,b) => a.timestamp.compareTo(b.timestamp))).first.timestamp,
        taps: placeDetail.taps,
        popularBeers: placeDetail.popularBeers,
      );
      _controller.sink.add(placeDetail);
    }
  }

  /// Callback when place's on-tap list is updated
  _onTapUpdate(List<OnTapBeer> event) {
    var newTaps = event;
    placeDetail = PlaceDetail(
      place: placeDetail.place,
      events: placeDetail.events,
      checkInsCount: placeDetail.checkInsCount,
      firstCheckIn: placeDetail.firstCheckIn,
      taps: newTaps,
      popularBeers: placeDetail.popularBeers,
    );
    _controller.sink.add(placeDetail);
  }

  /// Callback when all beers are updated
  _onBeersUpdate(List<Beer> event) {
    var newBeers = event;
    placeDetail = PlaceDetail(
      place: placeDetail.place,
      events: placeDetail.events,
      checkInsCount: placeDetail.checkInsCount,
      firstCheckIn: placeDetail.firstCheckIn,
      taps: placeDetail.taps,
      popularBeers: newBeers,
    );
    _controller.sink.add(placeDetail);
  }

  /// Dispose object
  void dispose() {
    _placesSubscription.cancel();
    _checkInsSubscription.cancel();
    _tapSubscription.cancel();
    _eventsSubscription.cancel();
    _allBeersSubscription.cancel();
    _controller.close();
  }
}

/// Holds information on a place and the user's
/// number of check ins
class PlaceDetail {
  /// The trail place
  final TrailPlace place;

  /// The beers currently on tap (if known)
  List<OnTapBeer> taps;

  /// The upcoming events for this [place]
  List<TrailEvent> events;

  /// The top 25 popular beers according to unTappd
  List<Beer> popularBeers;

  /// The number of times the current user has checked in
  int checkInsCount;

  /// The date of the first check in
  DateTime firstCheckIn;

  /// Default constructor
  PlaceDetail(
      {this.place,
      this.checkInsCount,
      this.firstCheckIn,
      this.taps,
      this.events,
      this.popularBeers});
}
