import 'dart:async';

import 'package:alabama_beer_trail/data/user_data.dart';

import 'bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/check_in.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';

class ProfileStatsAreaBloc extends Bloc {
  final _db = TrailDatabase();
  StreamSubscription _checkInSubscription;
  StreamSubscription _placesSubscription;
  StreamSubscription _userDataSubscription;

  List<UserPlaceInformation> userPlacesInformation =
      List<UserPlaceInformation>();
  var _places = List<TrailPlace>();
  var _checkIns = List<CheckIn>();
  var _favorites = List<String>();

  final _streamController = StreamController<List<UserPlaceInformation>>();
  get stream => _streamController.stream;

  ProfileStatsAreaBloc() {
    _places = _db.places;
    _checkIns = _db.checkIns;
    _favorites = _db.userData.favorites ?? List<String>();
    _placesSubscription = _db.placesStream.listen(_onPlacesUpdated);
    _checkInSubscription = _db.checkInStream.listen(_onCheckInsUpdated);
    _userDataSubscription = _db.userDataStream.listen(_onUserDataUpdated);
    userPlacesInformation = _buildStream(_places, _checkIns, _favorites);
  }

  List<UserPlaceInformation> _buildStream(
      List<TrailPlace> places, List<CheckIn> checkIns, List<String> favorites) {
    List<UserPlaceInformation> retval = List<UserPlaceInformation>();
    places.forEach((p) {
      retval.add(UserPlaceInformation(p, checkIns.any((c) => c.placeId == p.id),
        favorites.contains(p.id)));
    });
    return retval;
  }

  void _onPlacesUpdated(List<TrailPlace> event) {
    _places = event;
    userPlacesInformation = _buildStream(_places, _checkIns, _favorites);
    _streamController.add(null);
    _streamController.sink.add(userPlacesInformation);
  }

  void _onCheckInsUpdated(List<CheckIn> event) {
    _checkIns = event;
    userPlacesInformation = _buildStream(_places, _checkIns, _favorites);
    _streamController.add(null);
    _streamController.sink.add(userPlacesInformation);
  }

  void _onUserDataUpdated(UserData userData) {
    _favorites = userData.favorites ?? List<String>();
    userPlacesInformation = _buildStream(_places, _checkIns, _favorites);
    _streamController.add(null);
    _streamController.sink.add(userPlacesInformation);
  }

  @override
  void dispose() {
    _streamController.close();
    _checkInSubscription.cancel();
    _placesSubscription.cancel();
    _userDataSubscription.cancel();
  }
}

class UserPlaceInformation {
  final TrailPlace place;
  final bool userHasCheckedIn;
  final bool isUserFavorite;

  UserPlaceInformation(this.place, this.userHasCheckedIn, this.isUserFavorite);
}
