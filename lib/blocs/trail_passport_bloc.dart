// Copyright (c) 2021, Fermented Software.
import 'dart:async';

import 'package:alabama_beer_trail/data/check_in.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';

import 'bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';

/// A BLoC for ScreenStamps objects
class TrailPassportBloc extends Bloc {
  TrailDatabase _db;

  List<TrailPlace> _places;

  List<CheckIn> _checkIns;

  StreamSubscription _placesSubscription;

  StreamSubscription _checkInSubscription;

  List<StampInformation> stampInformation = <StampInformation>[];

  StreamController<List<StampInformation>> _streamController =
      StreamController<List<StampInformation>>();

  Stream<List<StampInformation>> get stream => _streamController.stream;

  TrailPassportBloc(TrailDatabase db) {
    _db = db;
    _places = _db.places;
    _checkIns = _db.checkIns;
    _placesSubscription = _db.placesStream.listen(_onPlacesUpdate);
    _checkInSubscription = _db.checkInStream.listen(_onCheckInUpdate);
    _buildAndSendStampedInformation();
  }

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

  void _onPlacesUpdate(List<TrailPlace> event) {
    _places = event;
    _buildAndSendStampedInformation();
  }

  void _onCheckInUpdate(List<CheckIn> event) {
    _checkIns = event;
    _buildAndSendStampedInformation();
  }

  @override
  void dispose() {
    _placesSubscription.cancel();
    _checkInSubscription.cancel();
    _streamController.close();
  }
}

class StampInformation {
  final TrailPlace place;
  final bool isStamped;
  final DateTime stampDate;
  final int checkInCount;

  StampInformation(
      {this.place, this.isStamped, this.stampDate, this.checkInCount});
}
