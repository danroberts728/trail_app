// Copyright (c) 2020, Fermented Software.
import 'dart:async';

import 'package:alabama_beer_trail/blocs/bloc.dart';
import 'package:alabama_beer_trail/model/on_tap_beer.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';

/// BLoC for a TrailPlaceOnTap screen
class TrailPlaceOnTapBloc extends Bloc {
  TrailDatabase _db;
  String _placeId;
  List<OnTapBeer> onTapNow;

  final _beersOnTapController = StreamController<List<OnTapBeer>>();
  Stream<List<OnTapBeer>> get stream => _db.getTaps(_placeId).asStream();

  /// Default constructor
  TrailPlaceOnTapBloc(String placeId, TrailDatabase db)
      : assert(placeId != null),
        assert(db != null) {
    _db = db;
    _placeId = placeId;
    _beersOnTapController.stream.listen(_onTapsUpdate);
  }

  void _onTapsUpdate(List<OnTapBeer> event) {
    onTapNow = event;
    _beersOnTapController.sink.add(onTapNow);
  }

  @override
  void dispose() {
    _beersOnTapController.close();
  }
}
