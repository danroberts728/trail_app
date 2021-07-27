// Copyright (c) 2021, Fermented Software.
import 'dart:async';

import 'package:trail_database/domain/check_in.dart';
import 'package:trail_database/domain/trail_place.dart';

import 'package:trail_database/trail_database.dart';

/// A BLoC for ScreenStamps objects
class TrailPassportBloc {
  /// A reference to the cetnral database
  TrailDatabase _db;

  /// The current trail places
  List<TrailPlace> _places;

  /// The user's current check ins
  List<CheckIn> _checkIns;

  /// A subscription to the trail places
  StreamSubscription _placesSubscription;

  /// A subscription to the user's check ins
  StreamSubscription _checkInSubscription;

  /// The current stamp information for the user
  List<StampInformation> stampInformation = <StampInformation>[];

  /// This BLoC's stream controller
  StreamController<List<StampInformation>> _streamController =
      StreamController<List<StampInformation>>();

  /// The stream for this BLoC that contains a list of
  /// the user's stamp information, sorted alphabetically by place name
  Stream<List<StampInformation>> get stream => _streamController.stream;

  /// Default constructor
  TrailPassportBloc(TrailDatabase db) : assert(db != null) {
    _db = db;
    _places = _db.places;
    _checkIns = _db.checkIns;
    _placesSubscription = _db.placesStream.listen(_onPlacesUpdate);
    _checkInSubscription = _db.checkInStream.listen(_onCheckInUpdate);
    _buildAndSendStampedInformation();
  }

  /// Build and send the stream to subscribers
  void _buildAndSendStampedInformation() {
    List<StampInformation> info = <StampInformation>[];

    var places = List<TrailPlace>.from(_places);    
    places.sort((a,b) => a.name.compareTo(b.name));
    places.forEach((p) { 
      var thisPlaceCheckIns = _checkIns.where((c) => c.placeId == p.id).toList();
      bool isStamped = thisPlaceCheckIns.isNotEmpty;
      DateTime stampedDate = isStamped
        ? (thisPlaceCheckIns..sort((a,b) => a.timestamp.compareTo(b.timestamp))).first.timestamp
        : null;
      var checkInCount = thisPlaceCheckIns.length;

      info.add(StampInformation(
        place: p,
        checkInCount: checkInCount,
        isStamped: isStamped,
        stampDate: stampedDate,
      ));
    });

    stampInformation = info;
    _streamController.add(stampInformation);
  }

  /// Callback when trail places are updated
  void _onPlacesUpdate(List<TrailPlace> event) {
    _places = event;
    _buildAndSendStampedInformation();
  }

  /// Callback when check ins are updated
  void _onCheckInUpdate(List<CheckIn> event) {
    _checkIns = event;
    _buildAndSendStampedInformation();
  }

  /// Dispose object
  void dispose() {
    _placesSubscription.cancel();
    _checkInSubscription.cancel();
    _streamController.close();
  }
}

/// A class to represent the user's stamp status for a particular
/// place.
class StampInformation {
  /// The trail place
  final TrailPlace place;

  /// True if user has a stamp, false otherwise
  final bool isStamped;

  /// The data the stamp was earned
  /// 
  /// If [isStamped] is false, returns null
  final DateTime stampDate;

  /// The total number of checkins for this place
  final int checkInCount;

  /// Default constructor
  StampInformation(
      {this.place, this.isStamped, this.stampDate, this.checkInCount});
}
