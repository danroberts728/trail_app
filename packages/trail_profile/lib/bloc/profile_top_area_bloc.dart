// Copyright (c) 2020, Fermented Software.
import 'dart:async';

import 'package:trail_database/trail_database.dart';
import 'package:trail_database/domain/user_data.dart';

/// The BLoC for ProfileTopArea objects
class ProfileTopAreaBloc {
  /// A reference to the central database
  TrailDatabase _db;

  /// A subscription to the user's data
  StreamSubscription _userDataSubscription;

  /// the current user data
  UserData userData = UserData.createBlank();

  /// The controller for this BLoC's stream
  final _streamController = StreamController<UserData>();

  /// The stream for the user data
  get stream => _streamController.stream;

  /// Default constructor
  ProfileTopAreaBloc(TrailDatabase db) : assert(db != null) {
    _db = db;
    userData = _db.userData;
    _userDataSubscription = _db.userDataStream.listen(_onUserDataUpdate);
  }

  /// Callback when user's data is updated
  void _onUserDataUpdate(UserData event) {
    userData = event;
    _streamController.add(null);
    _streamController.sink.add(userData);
  }

  /// Dispose  object
  void dispose() {
    _streamController.close();
    _userDataSubscription.cancel();
  }
}
