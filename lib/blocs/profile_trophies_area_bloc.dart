import 'dart:async';

import 'bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/trail_trophy.dart';
import 'package:alabama_beer_trail/data/user_data.dart';

class ProfileTrophiesAreaBloc extends Bloc {
  final _db = TrailDatabase();
  StreamSubscription _trophiesSubscription;
  StreamSubscription _userDataSubscription;

  List<UserTrophyInformation> userTrophyInformation;
  List<TrailTrophy> _trailTrophies;
  UserData _userData;

  final _streamController = StreamController<List<UserTrophyInformation>>();
  get stream => _streamController.stream;

  ProfileTrophiesAreaBloc() {
    _trailTrophies = _db.trophies;
    _userData = _db.userData;
    userTrophyInformation = _buildStreamData(_trailTrophies, _userData);
    _trophiesSubscription = _db.trophiesStream.listen(_onTrophiesUpdate);
    _userDataSubscription = _db.userDataStream.listen(_onUserDataUpdate);
  }

  List<UserTrophyInformation> _buildStreamData(
      List<TrailTrophy> trophies, UserData userData) {
    if (trophies == null || userData == null || userData.trophies == null) {
      return List<UserTrophyInformation>();
    }
    var retval = List<UserTrophyInformation>();
    for (var trophy in trophies) {
      bool earned = userData.trophies.containsKey(trophy.id);
      retval.add(UserTrophyInformation(trophy, earned));
    }
    return retval;
  }

  void _onTrophiesUpdate(List<TrailTrophy> trophies) {
    _trailTrophies = trophies;
    userTrophyInformation = _buildStreamData(_trailTrophies, _userData);
    _streamController.add(userTrophyInformation);
  }

  void _onUserDataUpdate(UserData data) {
    _userData = data;
    userTrophyInformation = _buildStreamData(_trailTrophies, _userData);
    _streamController.add(userTrophyInformation);
  }

  @override
  void dispose() {
    _trophiesSubscription.cancel();
    _userDataSubscription.cancel();
    _streamController.close();
  }
}

class UserTrophyInformation {
  final TrailTrophy trophy;
  final bool userEarned;

  UserTrophyInformation(this.trophy, this.userEarned);
}
