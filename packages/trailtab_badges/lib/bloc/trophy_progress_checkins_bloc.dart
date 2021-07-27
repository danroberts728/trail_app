// Copyright (c) 2021, Fermented Software.
import 'dart:async';

import 'package:trail_database/domain/check_in.dart';
import 'package:trail_database/trail_database.dart';
import 'package:trail_database/domain/trail_place.dart';

/// This BLoC is used by multiple extensions of 
/// the trophy progress screens. This somewhat breaks
/// the ideal BLoC pattern for this app, but it is literally
/// the same exact requirements for the BLoC.
class TrophyProgressCheckinsBloc {
  final _db = TrailDatabase();
  StreamSubscription _placesSubscription;
  StreamSubscription _checkInSubscription;

  List<TrailPlace> _places;
  List<CheckIn> _checkIns;
  List<TrailPlaceCheckInStatus> placeStatuses;

  final _controller = StreamController<List<TrailPlaceCheckInStatus>>();
  Stream<List<TrailPlaceCheckInStatus>> get stream => _controller.stream;

  TrophyProgressCheckinsBloc() {
    _places = _db.places;
    _checkIns = _db.checkIns;
    _placesSubscription = _db.placesStream.listen(_onPlacesUpdate);
    _checkInSubscription = _db.checkInStream.listen(_onCheckInUpdate);
    _buildAndStreamPlaceStatuses();
  }

  void _onPlacesUpdate(List<TrailPlace> event) {
    _places = event;
    _buildAndStreamPlaceStatuses();
  }

  void _onCheckInUpdate(List<CheckIn> event) {
    _checkIns = event;
    _buildAndStreamPlaceStatuses();
  }

  void _buildAndStreamPlaceStatuses() {
    var newPlaceStatuses = <TrailPlaceCheckInStatus>[];
    _places.forEach((p) { 
      newPlaceStatuses.add(TrailPlaceCheckInStatus(
        place: p,
        hasUniqueCheckin: _checkIns.any((c) => c.placeId == p.id),
      ));
    });
    placeStatuses = newPlaceStatuses;
    _controller.sink.add(placeStatuses);
  }

  void dispose() {
    _controller.close();
    _placesSubscription.cancel();
    _checkInSubscription.cancel();
  }
}

class TrailPlaceCheckInStatus {
  final TrailPlace place;
  final bool hasUniqueCheckin;

  TrailPlaceCheckInStatus({this.place, this.hasUniqueCheckin});
}