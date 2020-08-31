import 'dart:async';

import 'package:alabama_beer_trail/blocs/bloc.dart';
import 'package:alabama_beer_trail/data/check_in.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';

class TrailPlaceCardBloc extends Bloc {
  final _db = TrailDatabase();
  StreamSubscription _placesSubscription;
  StreamSubscription _checkInsSubscription;

  String _placeId;
  int checkInsCount;

  final _controller = StreamController<int>();
  Stream<int> get stream => _controller.stream;

  TrailPlaceCardBloc(String placeId) {
    _placeId = placeId;
    checkInsCount = _db.checkIns.where((c) => c.placeId == placeId).length;    
    _controller.sink.add(checkInsCount);
    _checkInsSubscription = _db.checkInStream.listen(_onCheckInsUpdate);
  }

  _onCheckInsUpdate(List<CheckIn> event) {
    var newCheckInsCount = event.where((c) => c.placeId == _placeId).length;
    if(newCheckInsCount != checkInsCount) {
      checkInsCount = newCheckInsCount;
      _controller.sink.add(checkInsCount);
    }    
  }

  @override
  void dispose() {
    _placesSubscription.cancel();
    _checkInsSubscription.cancel();
    _controller.close();
  }
}