// Copyright (c) 2020, Fermented Software.
import 'dart:async';

import 'package:alabama_beer_trail/blocs/bloc.dart';
import 'package:alabama_beer_trail/data/check_in.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/data/trail_trophy.dart';
import 'package:alabama_beer_trail/data/user_data.dart';

/// A BLoC for ButtonCheckIn objects
class ButtonCheckInBloc extends Bloc {
  /// A reference to the central database.
  TrailDatabase _db;

  /// A subscription to the checkIns data stream
  StreamSubscription _checkInSubscription;

  /// A subscription to the trophies data stream
  StreamSubscription _trophySubscription;

  /// A subscription to the places data stream
  StreamSubscription _placeSubscription;

  /// A subscription to the user data data stream
  StreamSubscription _userDataSubscription;

  /// The user's check in's
  var checkIns = List<CheckIn>();

  /// All published trophies
  var _allTrophies = List<TrailTrophy>();

  /// All published places
  var _places = List<TrailPlace>();

  /// The current User's user data
  var _userData = UserData();

  /// The controller for this BLoC's stream
  final _streamController = StreamController<List<CheckIn>>();

  /// The stream of CheckIn data
  get stream => _streamController.stream;

  /// Default constructor
  ButtonCheckInBloc(TrailDatabase db) : assert(db != null) {
    _db = db;
    checkIns = _db.checkIns;
    _allTrophies = _db.trophies;
    _places = _db.places;
    _userData = _db.userData;
    _checkInSubscription = _db.checkInStream.listen(_onCheckInsUpdate);
    _trophySubscription = _db.trophiesStream.listen(_onTrophiesUpdate);
    _placeSubscription = _db.placesStream.listen(_onPlacesUpdate);
    _userDataSubscription = _db.userDataStream.listen(_onUserDataUpdate);
  }

  /// Returns true if the current user has checked into [placeId] today,
  /// false otherwise.
  /// If [today] is not provided, it will default to DateTime.now()
  bool isCheckedInToday(String placeId, {DateTime today}) {
    if(today == null) {
      today = DateTime.now();
    }
    return checkIns
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
        var earnedTrophies = List<TrailTrophy>();
        // See if user has earned any NEW trophies
        _allTrophies.forEach((t) {
          if (t.conditionsMet(checkIns, _places) &&
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

  /// Callback when the check in subscription gets
  /// new data
  void _onCheckInsUpdate(List<CheckIn> event) {
    checkIns = event;
    _streamController.sink.add(checkIns);
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

  /// Dispose of the object
  @override
  void dispose() {
    _checkInSubscription.cancel();
    _trophySubscription.cancel();
    _placeSubscription.cancel();
    _userDataSubscription.cancel();
    _streamController.close();
  }
}
