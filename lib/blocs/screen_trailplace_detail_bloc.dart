import 'dart:async';

import 'package:alabama_beer_trail/blocs/bloc.dart';
import 'package:alabama_beer_trail/data/check_in.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';

class ScreenTrailPlaceDetailBloc extends Bloc {
  final _db = TrailDatabase();
  StreamSubscription _placesSubscription;
  StreamSubscription _checkInsSubscription;

  PlaceDetail placeDetail;

  String _placeId;

  final _controller = StreamController<PlaceDetail>();
  Stream<PlaceDetail> get stream => _controller.stream;

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

  _onPlacesUpdate(List<TrailPlace> event) {
    var newPlace = event.firstWhere((p) => p.id == _placeId);
    PlaceDetail retval = PlaceDetail(
      place: newPlace,
      checkInsCount: placeDetail.checkInsCount,
    );
    _controller.sink.add(retval);
  }

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

  @override
  void dispose() {
    _placesSubscription.cancel();
    _checkInsSubscription.cancel();
    _controller.close();
  }
}

class PlaceDetail {
  final TrailPlace place;
  int checkInsCount;

  PlaceDetail({this.place, this.checkInsCount});
}
