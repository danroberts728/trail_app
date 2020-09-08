import 'dart:async';

import 'bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/check_in.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';

class ProfileStatsAreaBloc extends Bloc {
  final _db = TrailDatabase();
  StreamSubscription _checkInSubscription;
  StreamSubscription _placesSubscription;

  List<UserPlaceInformation> userPlacesInformation =
      List<UserPlaceInformation>();
  var _places = List<TrailPlace>();
  var _checkIns = List<CheckIn>();

  final _streamController = StreamController<List<UserPlaceInformation>>();
  get stream => _streamController.stream;

  ProfileStatsAreaBloc() {
    _places = _db.places;
    _checkIns = _db.checkIns;
    _placesSubscription = _db.placesStream.listen(_onPlacesUpdated);
    _checkInSubscription = _db.checkInStream.listen(_onCheckInsUpdated);
      userPlacesInformation = _buildStream(_places, _checkIns);
  }

  List<UserPlaceInformation> _buildStream(
      List<TrailPlace> places, List<CheckIn> checkIns) {
    List<UserPlaceInformation> retval = List<UserPlaceInformation>();
    places.forEach((p) {
      retval
          .add(UserPlaceInformation(p, checkIns.any((c) => c.placeId == p.id)));
    });
    return retval;
  }

  void _onPlacesUpdated(List<TrailPlace> event) {
    _places = event;
    userPlacesInformation = _buildStream(_places, _checkIns);
    _streamController.add(null);
    _streamController.sink.add(userPlacesInformation);
  }

  void _onCheckInsUpdated(List<CheckIn> event) {
    _checkIns = event;
    userPlacesInformation = _buildStream(_places, _checkIns);
    _streamController.add(null);
    _streamController.sink.add(userPlacesInformation);
  }

  @override
  void dispose() {
    _streamController.close();
    _checkInSubscription.cancel();
    _placesSubscription.cancel();
  }
}

class UserPlaceInformation {
  final TrailPlace place;
  final bool userHasCheckedIn;

  UserPlaceInformation(this.place, this.userHasCheckedIn);
}
