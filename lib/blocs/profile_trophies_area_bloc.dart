// Copyright (c) 2020, Fermented Software.
import 'dart:async';

import 'package:alabama_beer_trail/blocs/bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/trail_trophy.dart';
import 'package:alabama_beer_trail/data/user_data.dart';

/// The BLoC for ProfileTrophyArea objects
class ProfileTrophiesAreaBloc extends Bloc {
  /// A reference to the central database
  final _db = TrailDatabase();

  /// A subscription to all published trophies
  StreamSubscription _trophiesSubscription;

  /// A subscription to the user's data
  StreamSubscription _userDataSubscription;

  /// The current user trophy information
  List<UserTrophyInformation> userTrophyInformation;

  /// The current list of all published trail trophies
  List<TrailTrophy> _trailTrophies;

  /// The current user data
  UserData _userData;

  /// Controller for this BLoC's stream
  final _streamController = StreamController<List<UserTrophyInformation>>();

  /// The stream for this BLoC's UserTrophyInformation
  get stream => _streamController.stream;

  /// Default constructor
  ProfileTrophiesAreaBloc() {
    _trailTrophies = _db.trophies;
    _userData = _db.userData;
    userTrophyInformation = _buildStreamData(_trailTrophies, _userData);
    _trophiesSubscription = _db.trophiesStream.listen(_onTrophiesUpdate);
    _userDataSubscription = _db.userDataStream.listen(_onUserDataUpdate);
  }

  /// Builds the list of UserTrophyInformation to be sent to subscribers
  /// on update.
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

  /// Callback when trophy data is updated
  void _onTrophiesUpdate(List<TrailTrophy> trophies) {
    _trailTrophies = trophies;
    userTrophyInformation = _buildStreamData(_trailTrophies, _userData);
    _streamController.add(userTrophyInformation);
  }

  /// Callback when user's data is updated
  void _onUserDataUpdate(UserData data) {
    _userData = data;
    userTrophyInformation = _buildStreamData(_trailTrophies, _userData);
    _streamController.add(userTrophyInformation);
  }

  /// Dispose object
  @override
  void dispose() {
    _trophiesSubscription.cancel();
    _userDataSubscription.cancel();
    _streamController.close();
  }
}

/// A trophy and whether the current user has
/// earned the trophy
class UserTrophyInformation {
  /// A trail trophy
  final TrailTrophy trophy;

  /// Whether the user has earned the trophy
  final bool userEarned;

  /// Default constructor
  UserTrophyInformation(this.trophy, this.userEarned);
}
