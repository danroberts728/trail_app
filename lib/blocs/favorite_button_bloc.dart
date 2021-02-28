// Copyright (c) 2020, Fermented Software.
import 'dart:async';

import 'package:beer_trail_app/blocs/bloc.dart';
import 'package:beer_trail_database/trail_database.dart';
import 'package:beer_trail_database/domain/user_data.dart';
import 'package:trail_auth/trail_auth.dart';

/// A BLoC for FavoriteButton objects
class FavoriteButtonBloc extends Bloc {
  /// A reference to the central database.
  TrailDatabase _db;

  /// A subscription to the user data data stream
  StreamSubscription _userDataSubscription;

  /// The place ID that the button is attached to
  String _placeId;

  /// True if the button is already favorited by the user,
  /// false otherwise
  bool isFavorite;

  /// The controller for this BLoC's stream
  final _controller = StreamController<bool>();

  /// The stream for this button's favorite status
  Stream<bool> get stream => _controller.stream;

  /// Default constructor. The button is affiliated with
  /// a particular [placeId].
  FavoriteButtonBloc(TrailDatabase db, String placeId)
      : assert(placeId != null),
        assert(db != null) {
    _db = db;
    _placeId = placeId;
    if (_db.userData.favorites == null) {
      // This is sometimes a race condition when the user is first being registered
      // To avoid errors, let's set this to false if it cannot find the userData.
      // It will be updated when the stream updates.
      isFavorite = false;
    } else {
      isFavorite = _db.userData.favorites.contains(_placeId);
    }
    _userDataSubscription = _db.userDataStream.listen(_onUserDataUpdate);
  }

  /// Callback when the user data gets new data
  void _onUserDataUpdate(UserData event) {
    var isItNow = _db.userData.favorites.contains(_placeId);
    if (isItNow != isFavorite || TrailAuth().user == null) {
      isFavorite = _db.userData.favorites.contains(_placeId);
      _controller.sink.add(isFavorite);
    }
  }

  /// Toggle the favorite on/off. If the user is not
  /// logged in, returns false. Otherwise returns true
  bool toggleFavorite() {
    if (TrailAuth().user == null) {
      return false;
    }
    List<String> allFavorites = List<String>.from(_db.userData.favorites);
    if (allFavorites.contains(_placeId)) {
      allFavorites.remove(_placeId);
    } else {
      allFavorites.add(_placeId);
    }
    _db.updateUserData({'favorites': allFavorites});
    return true;
  }

  /// Dispose the object
  @override
  void dispose() {
    _userDataSubscription.cancel();
    _controller.close();
  }
}
