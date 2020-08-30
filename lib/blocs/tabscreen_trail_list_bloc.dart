import 'dart:async';

import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';

import 'bloc.dart';

/// BLoC for the Trail List Tab screen
class TabScreenTrailListBloc extends Bloc {
  final TrailDatabase _db = TrailDatabase();
  StreamSubscription _placesSubscription;

  List<TrailPlace> trailPlaces = List<TrailPlace>();

  final _placesStreamController = StreamController<List<TrailPlace>>();
  Stream<List<TrailPlace>> get trailPlaceStream =>
      _placesStreamController.stream;

  TabScreenTrailListBloc() {
    trailPlaces = _db.places;
    _placesSubscription = _db.placesStream.listen(_onPlacesUpdate);
  }

  void _onPlacesUpdate(List<TrailPlace> places) {
    trailPlaces = places;
    _placesStreamController.sink.add(places);
  }

  @override
  void dispose() {
    _placesSubscription.cancel();
    _placesStreamController.close();
  }
}
