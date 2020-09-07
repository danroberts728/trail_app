import 'dart:async';

import 'package:alabama_beer_trail/blocs/bloc.dart';
import 'package:alabama_beer_trail/data/check_in.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/data/trail_trophy.dart';
import 'package:alabama_beer_trail/data/user_data.dart';

class ButtonCheckInBloc extends Bloc {
  var _db = TrailDatabase();
  StreamSubscription _checkInSubscription;
  StreamSubscription _trophySubscription;
  StreamSubscription _placeSubscription;
  StreamSubscription _userDataSubscription;

  var checkIns = List<CheckIn>();

  var _allTrophies = List<TrailTrophy>();
  var _places = List<TrailPlace>();
  var _userData = UserData();

  final _streamController = StreamController<List<CheckIn>>();
  get stream => _streamController.stream;

  ButtonCheckInBloc() {
    checkIns = _db.checkIns;
    _allTrophies = _db.trophies;
    _places = _db.places;
    _userData = _db.userData;
    _checkInSubscription = _db.checkInStream.listen(_onCheckInsUpdate);
    _trophySubscription = _db.trophiesStream.listen(_onTrophiesUpdate);
    _placeSubscription = _db.placesStream.listen(_onPlacesUpdate);
    _userDataSubscription = _db.userDataStream.listen(_onUserDataUpdate);
  }

  bool isCheckedInToday(String placeId) {
    return checkIns
            .where((e) {
              var now = DateTime.now();
              return e.placeId == placeId &&
                  now.day == e.timestamp.day &&
                  now.month == e.timestamp.month &&
                  now.year == e.timestamp.year;
            })
            .toList()
            .length >
        0;
  }

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

  void _onCheckInsUpdate(List<CheckIn> event) {
    checkIns = event;
    _streamController.sink.add(checkIns);
  }

  void _onTrophiesUpdate(List<TrailTrophy> event) {
    _allTrophies = event;
  }

  void _onPlacesUpdate(List<TrailPlace> event) {
    _places = event;
  }

  void _onUserDataUpdate(UserData event) {
    _userData = event;
  }

  @override
  void dispose() {
    _checkInSubscription.cancel();
    _trophySubscription.cancel();
    _placeSubscription.cancel();
    _userDataSubscription.cancel();
    _streamController.close();
  }
}
