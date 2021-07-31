import 'dart:async';

import 'package:trail_database/trail_database.dart';

class TrailPlacesBloc {
  TrailDatabase _db = TrailDatabase();

  StreamSubscription _placesSubscription;

  List<TrailPlace> places = <TrailPlace>[];

  StreamController<List<TrailPlace>> _controller = StreamController<List<TrailPlace>>();
  Stream<List<TrailPlace>> get stream => _controller.stream;

  TrailPlacesBloc() {
    places = _db.places;
    _placesSubscription = _db.placesStream.listen((newPlaces) { 
      places = newPlaces;
      _controller.add(places);
    });
  }

  void dispose() {
    _placesSubscription.cancel();
    _controller.close();
  }
}