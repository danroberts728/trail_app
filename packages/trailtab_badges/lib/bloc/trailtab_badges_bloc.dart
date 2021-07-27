// Copyright (c) 2021, Fermented Software.
import 'dart:async';

import 'package:trail_database/trail_database.dart';
import 'package:trail_database/domain/trail_trophy.dart';
import 'package:trail_database/domain/user_data.dart';

/// The BLoC for Badges tabscreen
class TrailTabBadgesBloc {
  /// A reference to the central database
  TrailDatabase _db;

  /// A subscription to all published trophies
  StreamSubscription _trophiesSubscription;

  /// A subscription to the user's data
  StreamSubscription _userDataSubscription;

  /// The current list of all published trail trophies
  List<TrailTrophy> _trailTrophies;

  /// The current user data
  UserData _userData;  

  /// The current user trophy information
  List<UserTrophyInformation> userTrophyInformation;

  /// Controller for this BLoC's trophy information stream
  final _trophyInformationStreamController = StreamController<List<UserTrophyInformation>>();

  /// The stream for this BLoC's UserTrophyInformation
  get userTrophyInformationStream => _trophyInformationStreamController.stream;

  /// Default constructor
  TrailTabBadgesBloc(TrailDatabase db) : assert(db != null) {
    _db = db;
    _trailTrophies = _db.trophies;
    _userData = _db.userData;
    userTrophyInformation = _buildTrophyStreamData(_trailTrophies, _userData);
    _trophiesSubscription = _db.trophiesStream.listen(_onTrophiesUpdate);
    _userDataSubscription = _db.userDataStream.listen(_onUserDataUpdate);
  }

  /// Builds the list of UserTrophyInformation to be sent to subscribers
  /// on update.
  List<UserTrophyInformation> _buildTrophyStreamData(
      List<TrailTrophy> trophies, UserData userData) {
    if (trophies == null || userData == null || userData.trophies == null) {
      return [];
    }
    List<UserTrophyInformation> retval = [];
    for (var trophy in trophies) {
      bool earned = userData.trophies.containsKey(trophy.id);
      retval.add(UserTrophyInformation(
          trophy, 
          earned, 
          earned ? userData.trophies[trophy.id] : null));
    }
    return retval;
  }

  /// Callback when trophy data is updated
  void _onTrophiesUpdate(List<TrailTrophy> trophies) {
    _trailTrophies = trophies;
    userTrophyInformation = _buildTrophyStreamData(_trailTrophies, _userData);
    _trophyInformationStreamController.add(userTrophyInformation);
  }

  /// Callback when user's data is updated
  void _onUserDataUpdate(UserData data) {
    _userData = data;
    userTrophyInformation = _buildTrophyStreamData(_trailTrophies, _userData);
    _trophyInformationStreamController.add(userTrophyInformation);
  }

  /// Dispose object
  void dispose() {
    _trophiesSubscription.cancel();
    _userDataSubscription.cancel();
    _trophyInformationStreamController.close();
  }
}

/// A trophy and whether the current user has
/// earned the trophy
class UserTrophyInformation {
  /// A trail trophy
  final TrailTrophy trophy;

  /// Whether the user has earned the trophy
  final bool userEarned;

  /// The date the trophy was earned.
  /// Null if not yet earned
  final DateTime earnedDate;

  /// Default constructor
  UserTrophyInformation(this.trophy, this.userEarned, this.earnedDate);
}

