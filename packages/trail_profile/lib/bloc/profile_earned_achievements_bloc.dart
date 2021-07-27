// Copyright (c) 2020, Fermented Software.
import 'dart:async';

import 'package:trail_database/trail_database.dart';
import 'package:trail_database/domain/trail_trophy.dart';
import 'package:trail_database/domain/user_data.dart';


/// BLoC for the ProfileEarnedAchievements widget
class ProfileEarnedAchievementsBloc {
  /// A reference to the central database
  TrailDatabase _db;

  /// The current user's UserData
  UserData _userData;

  /// A list of all possible trophies in the app
  List<TrailTrophy> _allTrophies;

  /// A subscription to the user data stream
  StreamSubscription _userDataSubscription;

  /// A subscription to the trophy stream
  StreamSubscription _trophySubscription;

  /// A list of the user's earned trophies
  List<TrailTrophy> userEarnedTrophies;

  /// The stream controller for this BLoC
  StreamController<List<TrailTrophy>> _streamController =
      StreamController<List<TrailTrophy>>();

  /// This BLoC's data stream of the user's earned trophies
  Stream<List<TrailTrophy>> get stream => _streamController.stream;

  /// Constructor
  ProfileEarnedAchievementsBloc(TrailDatabase db) {
    _db = db;
    _userData = _db.userData;
    _allTrophies = _db.trophies;
    _userDataSubscription = _db.userDataStream.listen(_onUserDataUpdate);
    _trophySubscription = _db.trophiesStream.listen(_onTrophiesUpdate);
    _buildAndSendStream();
  }

  /// Callback when user's data is updated
  _onUserDataUpdate(UserData data) {
    _userData = data;
    _buildAndSendStream();
  }

  /// Callback when the trophy list is updated
  _onTrophiesUpdate(List<TrailTrophy> trophies) {
    _allTrophies = trophies;
    _buildAndSendStream();
  }

  /// Build and send the stream to subscribers
  _buildAndSendStream() {
    if(userEarnedTrophies == null) {
      userEarnedTrophies = [];
    } 
    _allTrophies.forEach((t) {
      if (_userData.trophies.keys.contains(t.id) &&
          !userEarnedTrophies.contains(t)) {
        userEarnedTrophies.add(t);
      }
    });
    _streamController.add(userEarnedTrophies);
  }

  /// Dispose object
  void dispose() {
    _userDataSubscription.cancel();
    _trophySubscription.cancel();
    _streamController.close();
  }
}
