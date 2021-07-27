// Copyright (c) 2021, Fermented Software.
import 'dart:async';
import 'dart:math';

import 'package:trail_database/domain/check_in.dart';
import 'package:trail_database/domain/user_data.dart';
import 'package:trail_database/trail_database.dart';
import 'package:trail_location_service/trail_location_service.dart';
import 'package:trailtab_places/util/trailtab_places_settings.dart';

/// BLoC for the Trail Place Card
class TrailPlaceCardBloc {
  /// A reference to the central database
  TrailDatabase _db;

  /// A subscription to the trail places
  StreamSubscription _placeSubscription;

  /// A subscription to the user's check ins
  StreamSubscription _checkInsSubscription;

  /// A subscription to the trophies data stream
  StreamSubscription _trophySubscription;

  /// A subscription to the user data data stream
  StreamSubscription _userDataSubscription;

  /// The ID for this place
  String _placeId;

  /// The current user's check ins
  List<CheckIn> _checkIns;

  /// All published trophies
  List<TrailTrophy> _allTrophies = [];

  /// All published places
  List<TrailPlace> _places = [];

  /// The current User's user data
  var _userData = UserData();

  /// The number of checkins for this place
  int checkInsCount;

  /// Controller for this BLoC's stream
  final _controller = StreamController<int>();

  /// The stream for this BLoC
  Stream<int> get stream => _controller.stream;

  /// Default constructor
  TrailPlaceCardBloc(TrailDatabase db, String placeId)
      : assert(db != null),
        assert(placeId != null) {
    _db = db;
    _placeId = placeId;
    _checkIns = _db.checkIns.where((c) => c.placeId == placeId).toList();
    _allTrophies = _db.trophies;
    _userData = _db.userData;
    checkInsCount = _checkIns.length;
    _controller.sink.add(checkInsCount);
    _checkInsSubscription = _db.checkInStream.listen(_onCheckInsUpdate);
    _trophySubscription = _db.trophiesStream.listen(_onTrophiesUpdate);
    _placeSubscription = _db.placesStream.listen(_onPlacesUpdate);
    _userDataSubscription = _db.userDataStream.listen(_onUserDataUpdate);
  }

  /// Callback when check ins are updated
  _onCheckInsUpdate(List<CheckIn> event) {
    _checkIns = event.where((c) => c.placeId == _placeId).toList();
    var newCheckInsCount = _checkIns.length;
    if (newCheckInsCount != checkInsCount) {
      checkInsCount = newCheckInsCount;
      _controller.sink.add(checkInsCount);
    }
  }

  /// Get the first checkin for the user for this place
  ///
  /// Returns null if there are no check ins
  DateTime getFirstCheckIn() {
    return _checkIns.length > 0
        ? (_checkIns..sort((a, b) => a.timestamp.compareTo(b.timestamp)))
            .first
            .timestamp
        : null;
  }

  bool isLocationOn() {
    return TrailLocationService().lastLocation != null;
  }

  bool isCloseEnoughToCheckIn(Point placeLocation) {
    return _getDistance(placeLocation) <= TrailTabPlacesSettings().minDistanceToCheckIn;
  }

  double _getDistance(Point placeLocation) {
    if (TrailLocationService().lastLocation != null) {
      return GeoMethods.calculateDistance(
          TrailLocationService().lastLocation, placeLocation);
    } else {
      return double.infinity;
    }
  }

  /// Returns true if the current user has checked into [placeId] today,
  /// false otherwise.
  /// If [today] is not provided, it will default to DateTime.now()
  bool isCheckedInToday(String placeId, {DateTime today}) {
    if (today == null) {
      today = DateTime.now();
    }
    return _checkIns
            .where((e) {
              return e.placeId == placeId &&
                  today.day == e.timestamp.day &&
                  today.month == e.timestamp.month &&
                  today.year == e.timestamp.year;
            })
            .toList()
            .length >
        0;
  }

  /// Checks the current user into [placeId] now
  Future<List<TrailTrophy>> checkIn(String placeId) async {
    var completer = Completer<List<TrailTrophy>>();
    // Only update if user has not checked in today already
    if (!isCheckedInToday(placeId)) {
      _db.checkInNow(placeId).then((value) {
        List<TrailTrophy> earnedTrophies = [];
        // See if user has earned any NEW trophies
        _allTrophies.forEach((t) {
          if (t.conditionsMet(_checkIns, _places) &&
              !_userData.trophies.containsKey(t.id)) {
            earnedTrophies.add(t);
            _db.addTrophy(t);
          }
        });
        completer.complete(earnedTrophies);
      });
    }
    return completer.future;
  }

  /// Callback when the trophies subscription gets
  /// new data
  void _onTrophiesUpdate(List<TrailTrophy> event) {
    _allTrophies = event;
  }

  /// Callback when the placessubscription gets
  /// new data
  void _onPlacesUpdate(List<TrailPlace> event) {
    _places = event;
  }

  /// Callback when the user data subscription gets
  /// new data
  void _onUserDataUpdate(UserData event) {
    _userData = event;
  }

  /// Dipose object
  void dispose() {
    _placeSubscription.cancel();
    _checkInsSubscription.cancel();
    _trophySubscription.cancel();
    _userDataSubscription.cancel();
    _controller.close();
  }
}
