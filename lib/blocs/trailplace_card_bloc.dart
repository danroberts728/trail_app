// Copyright (c) 2021, Fermented Software.
import 'dart:async';

import 'package:beer_trail_app/blocs/bloc.dart';
import 'package:trail_database/domain/check_in.dart';
import 'package:trail_database/trail_database.dart';

/// BLoC for the Trail Place Card
class TrailPlaceCardBloc extends Bloc {
  /// A reference to the central database
  TrailDatabase _db;

  /// A subscription to the trail places
  StreamSubscription _placesSubscription;

  /// A subscription to the user's check ins
  StreamSubscription _checkInsSubscription;

  /// The ID for this place
  String _placeId;

  /// The current user's check ins
  List<CheckIn> _checkIns;
  
  /// The number of checkins for this place
  int checkInsCount;

  /// Controller for this BLoC's stream
  final _controller = StreamController<int>();

  /// The stream for this BLoC
  Stream<int> get stream => _controller.stream;

  /// Default constructor
  TrailPlaceCardBloc(TrailDatabase db, String placeId) : assert(db != null), assert(placeId != null) {
    _db = db;
    _placeId = placeId;
    _checkIns = _db.checkIns.where((c) => c.placeId == placeId).toList();
    checkInsCount = _checkIns.length;    
    _controller.sink.add(checkInsCount);
    _checkInsSubscription = _db.checkInStream.listen(_onCheckInsUpdate);
  }

  /// Callback when check ins are updated
  _onCheckInsUpdate(List<CheckIn> event) {
    _checkIns = event.where((c) => c.placeId == _placeId).toList();
    var newCheckInsCount = _checkIns.length;
    if(newCheckInsCount != checkInsCount) {
      checkInsCount = newCheckInsCount;
      _controller.sink.add(checkInsCount);
    }    
  }

  /// Get the first checkin for the user for this place
  /// 
  /// Returns null if there are no check ins
  DateTime getFirstCheckIn() {
    return _checkIns.length > 0
      ? (_checkIns..sort((a,b) => a.timestamp.compareTo(b.timestamp))).first.timestamp
      : null;
  }

  /// Dipose object
  @override
  void dispose() {
    _placesSubscription.cancel();
    _checkInsSubscription.cancel();
    _controller.close();
  }
}