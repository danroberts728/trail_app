// Copyright (c) 2021, Fermented Software.
import 'dart:async';
import 'dart:math';

import 'package:trail_database/trail_database.dart';
import 'package:trail_location_service/trail_location_service.dart';
import 'package:trailtab_places/util/trailtab_places_settings.dart';

/// BLoC for the Trail Place Card
class TrailPlaceCardBloc {
  /// The information for the widget
  TrailPlaceCardInfo trailPlaceCardInfo;

  /// A reference to the central database
  TrailDatabase _db;

  /// A subscription to the trail places
  StreamSubscription _placeSubscription;

  /// A subscription to the user's check ins
  StreamSubscription _checkInsSubscription;

  /// A subscription to the user data data stream
  StreamSubscription _userDataSubscription;

  /// A subcription to the location service
  StreamSubscription _locationSubscription;

  /// The ID for this place
  String _placeId;

  /// Controller and stream for this BLoC
  final _controller = StreamController<TrailPlaceCardInfo>();
  Stream<TrailPlaceCardInfo> get stream => _controller.stream;

  /// Default constructor
  TrailPlaceCardBloc(TrailDatabase db, String placeId)
      : assert(db != null),
        assert(placeId != null) {
    _db = db;
    _placeId = placeId;

    var now = DateTime.now();
    trailPlaceCardInfo = TrailPlaceCardInfo();
    trailPlaceCardInfo.checkInsCount =
        _db.checkIns.where((c) => c.placeId == placeId).toList().length;
    trailPlaceCardInfo.firstCheckin = trailPlaceCardInfo.checkInsCount < 1
        ? null
        : (_db.checkIns.where((c) => c.placeId == placeId).toList()
              ..sort((a, b) => a.timestamp.compareTo(b.timestamp)))
            .first
            .timestamp;
    trailPlaceCardInfo.isCheckedInToday = _db.checkIns.any((c) =>
        c.timestamp.day == now.day &&
        c.timestamp.month == now.month &&
        c.timestamp.year == now.year);
    trailPlaceCardInfo.closeEnoughToCheckIn = false;
    trailPlaceCardInfo.place = _db.places.firstWhere((p) => p.id == _placeId);
    _controller.sink.add(trailPlaceCardInfo);

    _checkInsSubscription = _db.checkInStream.listen(_onCheckInsUpdate);
    _placeSubscription = _db.placesStream.listen(_onPlacesUpdate);
    _locationSubscription =
        TrailLocationService().locationStream.listen(_onLocationUpdate);
  }

  /// Callback when check ins are updated
  _onCheckInsUpdate(List<CheckIn> event) {
    var newCheckInsCount =
        event.where((c) => c.placeId == _placeId).toList().length;
    if (newCheckInsCount != trailPlaceCardInfo.checkInsCount) {
      trailPlaceCardInfo.checkInsCount = newCheckInsCount;
    }

    var today = DateTime.now();
    var isCheckedInToday = event.where((c) {
          return event
                  .where((e) {
                    return e.placeId == _placeId &&
                        today.day == e.timestamp.day &&
                        today.month == e.timestamp.month &&
                        today.year == e.timestamp.year;
                  })
                  .toList()
                  .length >
              0;
        }).length >
        0;
    if (isCheckedInToday != trailPlaceCardInfo.isCheckedInToday) {
      trailPlaceCardInfo.isCheckedInToday =
          !trailPlaceCardInfo.isCheckedInToday;
    }

    var firstCheckIn = event.length > 0
        ? (event..sort((a, b) => a.timestamp.compareTo(b.timestamp)))
            .first
            .timestamp
        : null;
    if (firstCheckIn != trailPlaceCardInfo.firstCheckin) {
      trailPlaceCardInfo.firstCheckin = firstCheckIn;
    }
    _controller.sink.add(trailPlaceCardInfo);
  }

  /// Callback when the placessubscription gets
  /// new data
  void _onPlacesUpdate(List<TrailPlace> event) {
    var places = event.where((p) => p.id == _placeId);
    if (places.length == 1) {
      trailPlaceCardInfo.place = places.first;
      _controller.sink.add(trailPlaceCardInfo);
    }
  }

  /// Callback when the location subscription gets
  /// new data
  void _onLocationUpdate(Point<num> event) {
    var closeEnoughToCheckIn = GeoMethods.calculateDistance(
            event, trailPlaceCardInfo.place.location) <=
        TrailTabPlacesSettings().minDistanceToCheckIn;
    if (closeEnoughToCheckIn != trailPlaceCardInfo.closeEnoughToCheckIn) {
      trailPlaceCardInfo.closeEnoughToCheckIn = closeEnoughToCheckIn;
      _controller.sink.add(trailPlaceCardInfo);
    }
  }

  /// Checks the current user into [placeId] now
  Future<List<TrailTrophy>> checkIn(String placeId) async {
    var completer = Completer<List<TrailTrophy>>();
    // Only update if user has not checked in today already
    if (!trailPlaceCardInfo.isCheckedInToday) {
      _db.checkInNow(placeId).then((value) {
        List<TrailTrophy> earnedTrophies = [];
        // See if user has earned any NEW trophies
        _db.trophies.forEach((t) {
          if (t.conditionsMet(_db.checkIns.where((c) => c.placeId == _placeId),
                  _db.places) &&
              !_db.userData.trophies.containsKey(t.id)) {
            earnedTrophies.add(t);
            _db.addTrophy(t);
          }
        });
        completer.complete(earnedTrophies);
      });
    }
    return completer.future;
  }

  /// Dipose object
  void dispose() {
    _placeSubscription.cancel();
    _checkInsSubscription.cancel();
    _userDataSubscription.cancel();
    _locationSubscription.cancel();
    _controller.close();
  }
}

class TrailPlaceCardInfo {
  int checkInsCount;
  bool closeEnoughToCheckIn;
  bool isCheckedInToday;
  DateTime firstCheckin;
  TrailPlace place;
}
