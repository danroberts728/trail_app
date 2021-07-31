// Copyright (c) 2021, Fermented Software.

import 'dart:async';

import 'package:trail_database/domain/trail_region.dart';
import 'package:trail_database/trail_database.dart';

class TrailPassportBloc {
  /// A reference to the central database
  TrailDatabase _db;

  /// The regions
  List<TrailRegion> regions;

  /// A subscription to the trail regions
  StreamSubscription _regionsSubscription;

  /// This BLoC's stream controller
  StreamController<List<TrailRegion>> _streamController =
      StreamController<List<TrailRegion>>();

  /// The stream for this BLoC that contains a list of
  /// the user's stamp information, sorted alphabetically by place name
  Stream<List<TrailRegion>> get stream => _streamController.stream;

  TrailPassportBloc(TrailDatabase db) : assert(db != null) {
    _db = db;
    regions = _db.regions..sort((a,b) => a.sortOrder.compareTo(b.sortOrder));
    _regionsSubscription = _db.regionsStream.listen(_onRegionsUpdate);
  }

  void _onRegionsUpdate(List<TrailRegion> event) {
    regions = event..sort((a,b) => a.sortOrder.compareTo(b.sortOrder));
    _streamController.sink.add(regions);
  }

  void dispose() {
    _streamController.close();
    _regionsSubscription.cancel();
  }
}