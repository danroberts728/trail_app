// Copyright (c) 2020, Fermented Software.
import 'dart:async';

import 'package:alabama_beer_trail/blocs/bloc.dart';
import 'package:alabama_beer_trail/model/beer.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';

/// BLoC for a TrailPlaceBeers screen
class TrailPlaceBeersBloc extends Bloc {
  TrailDatabase _db;
  String _placeId;

  final _popularBeersController = StreamController<List<Beer>>();
  Stream<List<Beer>> get stream => _db.getPopularBeers(_placeId).asStream();

  /// Default constructor
  TrailPlaceBeersBloc(String placeId, TrailDatabase db) {
    _db = db;
    _placeId = placeId;
  }

  @override
  void dispose() {
    _popularBeersController.close();
  }
}