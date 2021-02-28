// Copyright (c) 2020, Fermented Software.
import 'dart:async';

import 'package:beer_trail_app/blocs/bloc.dart';
import 'package:beer_trail_database/trail_database.dart';
import 'package:beer_trail_database/domain/user_data.dart';

/// The BLoC for TrophyDetailScreen objects
class ScreenTrailTrophyBloc extends Bloc {
  /// A reference to the central database
  TrailDatabase _db;

  /// A subscription to the user's data
  StreamSubscription _userDataSubscription;

  /// The list of the user's earned trophies
  Map<String, DateTime> earnedTrophies;

  /// Controller for this BLoC's stream
  final _controller = StreamController<Map<String, DateTime>>();

  /// Stream for the user's earned trophies
  Stream<Map<String, DateTime>> get stream => _controller.stream;

  /// Default constructor
  ScreenTrailTrophyBloc(TrailDatabase db) : assert(db != null) {
    _db = db;
    earnedTrophies = _db.userData.trophies;
    _userDataSubscription = _db.userDataStream.listen(_onUserDataUpdate);
  }

  /// Callback for user data updates
  void _onUserDataUpdate(UserData event) {
    earnedTrophies = event.trophies;
    _controller.sink.add(earnedTrophies);
  }

  /// Dispose object
  @override
  void dispose() {
    _userDataSubscription.cancel();
    _controller.close();
  }

}