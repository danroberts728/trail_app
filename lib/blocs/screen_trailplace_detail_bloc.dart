// Copyright (c) 2020, Fermented Software.
import 'dart:async';

import 'package:alabama_beer_trail/blocs/bloc.dart';
import 'package:alabama_beer_trail/data/check_in.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';

/// The BLoC for ScreenTrailPlaceDetail objects
class ScreenTrailPlaceDetailBloc extends Bloc {
  /// A reference to the central database
  final _db = TrailDatabase();

  /// A subscription to all published places
  StreamSubscription _placesSubscription;

  /// A subscription to the user's check ins
  StreamSubscription _checkInsSubscription;

  /// The current place's detail information
  PlaceDetail placeDetail;

  /// The place ID that this BLoC is affiliated with
  String _placeId;

  /// Controller for this BLoC's stream
  final _controller = StreamController<PlaceDetail>();

  /// The stream for the PlaceDetail information
  Stream<PlaceDetail> get stream => _controller.stream;

  /// Default constructor. Each instance of this BLoC is
  /// associated with a single [place].
  ScreenTrailPlaceDetailBloc(TrailPlace place) {
    _placeId = place.id;
    var checkInCount = _db.checkIns.where((c) => c.placeId == _placeId).length;
    placeDetail = PlaceDetail(
      place: place,
      checkInsCount: checkInCount,
    );
    _placesSubscription = _db.placesStream.listen(_onPlacesUpdate);
    _checkInsSubscription = _db.checkInStream.listen(_onCheckInsUpdate);
  }

  /// Callback when trail places are updated
  _onPlacesUpdate(List<TrailPlace> event) {
    var newPlace = event.firstWhere((p) => p.id == _placeId);
    PlaceDetail retval = PlaceDetail(
      place: newPlace,
      checkInsCount: placeDetail.checkInsCount,
    );
    _controller.sink.add(retval);
  }

  /// Whether the place has any upcoming events.
  /// 
  /// In order to be true, the event must have the same
  /// location taxonomy and end before or at now.
  bool placeHasUpcomingEvents() {
    try {
      return _db.events.where((e) => 
          e.locationTaxonomy == placeDetail.place.locationTaxonomy
          && e.end.compareTo(DateTime.now()) >= 0).length > 0;
    } catch (err) {
      print(err);
      return false;
    }
    
  }

  /// Callback when user's check ins are updated
  _onCheckInsUpdate(List<CheckIn> event) {
    var newCheckInsCount = event.where((c) => c.placeId == _placeId).length;
    if(newCheckInsCount != placeDetail.checkInsCount) {
      PlaceDetail retval = PlaceDetail(
        place: placeDetail.place,
        checkInsCount: newCheckInsCount,
      );
      _controller.sink.add(retval);
    }
    
  }

  /// Dispose object
  @override
  void dispose() {
    _placesSubscription.cancel();
    _checkInsSubscription.cancel();
    _controller.close();
  }
}

/// Holds information on a place and the user's
/// number of check ins
class PlaceDetail {
  /// The trail place
  final TrailPlace place;

  /// The number of times the current user has checked in
  int checkInsCount;

  /// Default constructor
  PlaceDetail({this.place, this.checkInsCount});
}
