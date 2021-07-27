// Copyright (c) 2020, Fermented Software.
import 'dart:async';

import 'package:intl/intl.dart';

import 'package:trail_database/trail_database.dart';
import 'package:trail_database/domain/user_data.dart';

/// The BLoC for EditProfileScreen objects
class ScreenEditProfileBloc {
  /// A reference to the central database
  TrailDatabase _db;

  /// A subscription to the user's data
  StreamSubscription _userDataSubscription;

  /// The user's current data
  UserData userData;

  /// Controller for this BLoC's stream
  final _controller = StreamController<UserData>();

  /// A Stream for this user's data
  Stream<UserData> get stream => _controller.stream;

  /// Default constructor
  ScreenEditProfileBloc(TrailDatabase db) : assert(db != null) {
    _db = db;
    userData = _db.userData;
    _userDataSubscription = _db.userDataStream.listen(_onUserDataUpdate);
  }

  /// Callback when user's data is updated
  void _onUserDataUpdate(UserData event) {
    userData = event;
    _controller.sink.add(userData);
  }

  /// Updates the current user's display name with [value]
  void updateDisplayName(String value) {
    _db.updateUserData({'displayName': value});
  }

  /// Updates the current user's location with [value]
  void updateLocation(String value) {
    _db.updateUserData({'location': value});
  }

  /// Updates the current user's date of birth with [value]
  /// [value] must be in *MMM d y* format
  void updateDob(String value) {
    if (value == null || value.isEmpty) {
      return;
    }
    try {
      _db.updateUserData({'birthdate': DateFormat("MMM d y").parse(value)});
    } catch (err) {
      print(err);
    }
  }

  /// Updates the current user's *About You* with [value]
  void updateAboutYou(String value) {
    _db.updateUserData({'aboutYou': value});
  }

  /// Dispose object
  void dispose() {
    _userDataSubscription.cancel();
    _controller.close();
  }
}
