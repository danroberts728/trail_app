// Copyright (c) 2020, Fermented Software.
import 'dart:async';

import 'package:alabama_beer_trail/blocs/bloc.dart';
import 'package:alabama_beer_trail/data/beer.dart';
import 'package:alabama_beer_trail/data/check_in.dart';
import 'package:alabama_beer_trail/data/on_tap_beer.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/trail_event.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';

/// The BLoC for ScreenTrailPlaceDetail objects
class ScreenTrailPlaceDetailBloc extends Bloc {
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

    // Initial data
    placeDetail = PlaceDetail(
      place: _db.places.firstWhere((p) => p.id == _placeId),
      checkInsCount: _db.checkIns.where((c) => c.placeId == _placeId).length,
      taps: List<OnTapBeer>(),
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
      taps: newTaps,
      popularBeers: placeDetail.popularBeers,
    );
    _controller.sink.add(placeDetail);
  }

  _onBeersUpdate(List<Beer> event) {
    var newBeers = event;
    placeDetail = PlaceDetail(
      place: placeDetail.place,
      events: placeDetail.events,
      checkInsCount: placeDetail.checkInsCount,
      taps: placeDetail.taps,
      popularBeers: newBeers,
    );
  }

  /// Dispose object
  @override
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

  List<OnTapBeer> taps;

  List<TrailEvent> events;

  List<Beer> popularBeers;

  /// The number of times the current user has checked in
  int checkInsCount;

  /// Default constructor
  PlaceDetail(
      {this.place,
      this.checkInsCount,
      this.taps,
      this.events,
      this.popularBeers});
}
