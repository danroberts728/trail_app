// Copyright (c) 2020, Fermented Software.
import 'dart:async';
import 'dart:math' as math;

import 'package:alabama_beer_trail/model/check_in.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/data/user_data.dart';
import 'package:alabama_beer_trail/model/activity_item.dart';

import 'bloc.dart';

/// BLoC for the TrailActivityLog widget
class TrailActivityLogBloc extends Bloc {
  /// The limit of the activities to return
  ///
  /// The object will return this or the total
  /// number of activities, whichever is smaller
  int limit;

  /// A reference to the cetnral database
  TrailDatabase _db;

  /// A list of the activities, bounded by [limit]
  List<ActivityItem> activities;

  /// A subscription to the current user's check ins
  StreamSubscription _checkInSubscription;

  /// A subscription to the current user's data
  StreamSubscription _userDataSubscription;

  /// A subscription to the trail places
  StreamSubscription _placesSubscription;

  /// The user's check ins
  List<CheckIn> _checkIns;

  /// The user's data
  UserData _userData;

  /// The trail places
  List<TrailPlace> _places;

  /// This BLoC's stream controller
  StreamController<List<ActivityItem>> _controller =
      StreamController<List<ActivityItem>>();

  /// The stream for this BLoC that contains a list of
  /// the user's activity, bounded by [limit] and sorted
  /// by date (newest first)
  get stream => _controller.stream;

  /// Constructor
  TrailActivityLogBloc(TrailDatabase db, this.limit)
      : assert(db != null),
        assert(limit == null || limit > 0) {
    _db = db;
    _checkIns = _db.checkIns;
    _userData = _db.userData;
    _places = _db.places;
    if (limit == null) {
      limit = _checkIns.length;
    }
    activities = _buildActivityItemList();
    _checkInSubscription = _db.checkInStream.listen(_onCheckInUpdate);
    _userDataSubscription = _db.userDataStream.listen(_onUserDataUpdate);
    _placesSubscription = _db.placesStream.listen(_onPlacesUpdate);
  }

  /// Callback when check ins are updated
  void _onCheckInUpdate(List<CheckIn> checkIns) {
    _checkIns = checkIns;
    _buildActivityItemList();
    _controller.add(activities);
  }

  /// Callback when user data is updated
  void _onUserDataUpdate(UserData data) {
    _userData = data;
    _buildActivityItemList();
    _controller.add(activities);
  }

  /// Callback when trail places are updated
  void _onPlacesUpdate(List<TrailPlace> places) {
    _places = places;
    _buildActivityItemList();
    _controller.add(activities);
  }

  /// Build and send the stream to subscribers
  List<ActivityItem> _buildActivityItemList() {
    activities = <ActivityItem>[];

    (_checkIns..sort((a, b) => b.timestamp.compareTo(a.timestamp)))
        .sublist(0, math.min(limit, _checkIns.length))
        .forEach((c) {
      if (_places.any((p) => p.id == c.placeId)) {
        activities.add(
          ActivityItem(
            date: c.timestamp,
            place: _places.firstWhere((p) => p.id == c.placeId),
            trophy: null,
            type: ActivityType.CheckIn,
            userImageUrl: _userData.profilePhotoUrl,
            userDisplayName: _userData.displayName,
          ),
        );
      }
    });

    return activities;
  }

  /// Dispose object
  @override
  void dispose() {
    _checkInSubscription.cancel();
    _userDataSubscription.cancel();
    _placesSubscription.cancel();
    _controller.close();
  }
}
