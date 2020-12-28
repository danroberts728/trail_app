import 'dart:async';

import 'package:alabama_beer_trail/blocs/bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';

class TrailSearchBloc extends Bloc {
  final _db = TrailDatabase();
  StreamSubscription _placesSubscription;

  List<TrailPlace> places = <TrailPlace>[];

  final _controller = StreamController<List<TrailPlace>>();
  Stream<List<TrailPlace>> get stream => _controller.stream;

  TrailSearchBloc() {
    places = _db.places;
    _controller.sink.close();
    _placesSubscription = _db.placesStream.listen(_onPlacesUpdate);
  }

  void _onPlacesUpdate(List<TrailPlace> event) {
    places = event;
    _controller.sink.add(places);
  }

  @override
  void dispose() {
    _placesSubscription.cancel();
    _controller.close();
  }

}