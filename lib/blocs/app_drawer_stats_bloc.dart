// Copyright (c) 2020, Fermented Software.
import 'dart:async';

import 'package:beer_trail_database/domain/user_data.dart';
import 'package:beer_trail_app/blocs/bloc.dart';
import 'package:beer_trail_database/trail_database.dart';
import 'package:beer_trail_database/domain/trail_place.dart';

/// The BLoC for ProfileStatsArea objects
class AppDrawerStatsBloc extends Bloc {
  /// A reference to the central database.
  TrailDatabase _db;

  /// A subscription to the user's check ins
  StreamSubscription _checkInSubscription;

  /// A subscription to the places
  StreamSubscription _placesSubscription;

  /// A subscription to the user's user data
  StreamSubscription _userDataSubscription;

  /// The current user places information
  List<UserPlaceInformation> userPlacesInformation = [];

  /// The current list of places
  List<TrailPlace> _places = [];

  /// The current list of the user's checkins
  List<CheckIn> _checkIns = [];

  /// The current list of the user's favorites
  List<String> _favorites = [];

  /// The controller for this BLoC's stream
  final _streamController = StreamController<List<UserPlaceInformation>>();

  /// The stream for the user place information
  get stream => _streamController.stream;

  /// Default constructor
  AppDrawerStatsBloc(TrailDatabase db) : assert(db != null) {
    _db = db;
    _places = _db.places;
    _checkIns = _db.checkIns;
    _favorites = _db.userData.favorites ??[];
    _placesSubscription = _db.placesStream.listen(_onPlacesUpdated);
    _checkInSubscription = _db.checkInStream.listen(_onCheckInsUpdated);
    _userDataSubscription = _db.userDataStream.listen(_onUserDataUpdated);
    userPlacesInformation = _buildStream(_places, _checkIns, _favorites);
  }

  /// Buil a list of UserPlaceInformation objects that can be sent to the stream
  List<UserPlaceInformation> _buildStream(
      List<TrailPlace> places, List<CheckIn> checkIns, List<String> favorites) {
    List<UserPlaceInformation> retval = [];
    places.forEach((p) {
      retval.add(UserPlaceInformation(
          p, checkIns.any((c) => c.placeId == p.id), favorites.contains(p.id)));
    });
    return retval;
  }

  /// Callback when places get new data
  void _onPlacesUpdated(List<TrailPlace> event) {
    _places = event;
    userPlacesInformation = _buildStream(_places, _checkIns, _favorites);
    _streamController.add(null);
    _streamController.sink.add(userPlacesInformation);
  }

  /// Callback when the user check ins get new data
  void _onCheckInsUpdated(List<CheckIn> event) {
    _checkIns = event;
    userPlacesInformation = _buildStream(_places, _checkIns, _favorites);
    _streamController.add(null);
    _streamController.sink.add(userPlacesInformation);
  }

  /// Callback when the user data gets new data
  void _onUserDataUpdated(UserData userData) {
    _favorites = userData.favorites ?? [];
    userPlacesInformation = _buildStream(_places, _checkIns, _favorites);
    _streamController.add(null);
    _streamController.sink.add(userPlacesInformation);
  }

  /// Dispose object
  @override
  void dispose() {
    _streamController.close();
    _checkInSubscription.cancel();
    _placesSubscription.cancel();
    _userDataSubscription.cancel();
  }
}

/// An object that combines a place with the current user's
/// check in status and whether it is a favorite
class UserPlaceInformation {
  /// The place that this object refers to
  final TrailPlace place;

  /// True if the user has checked into this place at any time
  final bool userHasCheckedIn;

  /// True if the user has this marked as a favorite place
  final bool isUserFavorite;

  /// Default constructor
  UserPlaceInformation(this.place, this.userHasCheckedIn, this.isUserFavorite);
}
