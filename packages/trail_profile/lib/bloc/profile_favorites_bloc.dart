// Copyright (c) 2020, Fermented Software.
import 'dart:async';

import 'package:trail_database/trail_database.dart';
import 'package:trail_database/domain/trail_place.dart';
import 'package:trail_database/domain/user_data.dart';

/// The BLoC for the ProfileFaorites screen
class ProfileFavoritesBloc {
  /// A refernece to the central database
  TrailDatabase _db;

  /// A list of the user's favorite TrailPlace places
  List<TrailPlace> get favorites {
    return _places.where((p) => _favoriteIds.contains(p.id)).toList();
  }

  /// A list of the user's favorite IDs from the User Data
  List<String> _favoriteIds;

  /// A list of all places in the trail
  List<TrailPlace> _places = [];

  /// Subscription to the User Data stream
  StreamSubscription _userDataSubscription;

  /// Subscription to the Places stream
  StreamSubscription _placesSubscription;

  /// This BLoC's stream controller
  StreamController<List<TrailPlace>> _streamController = StreamController<List<TrailPlace>>();

  /// The stream for this BLoC
  Stream<List<TrailPlace>> get stream => _streamController.stream;

  /// Constructor
  ProfileFavoritesBloc(TrailDatabase db) {
    _db = db;
    _places = _db.places;
    _favoriteIds = _db.userData.favorites;
    _userDataSubscription = _db.userDataStream.listen(_onUserDateUpdate);
    _placesSubscription = _db.placesStream.listen(_onPlacesUpdate);
    _buildAndSendStream();
  }

  /// Callback when user data is updated
  void _onUserDateUpdate(UserData data) {
    _favoriteIds = data.favorites;
    _buildAndSendStream();
  }

  /// Callback when trail places are updated
  void _onPlacesUpdate(List<TrailPlace> places) {
    _places = places;
    _buildAndSendStream();
  }

  /// Build and send the stream for this BLoC's subscribers
  void _buildAndSendStream() {
    _streamController.add(favorites..sort((a,b) => a.name.compareTo(b.name)));
  }

  /// Dispose object
  void dispose() {
    _userDataSubscription.cancel();
    _placesSubscription.cancel();
    _streamController.close();
  }

}