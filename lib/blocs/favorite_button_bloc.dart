import 'dart:async';

import 'package:alabama_beer_trail/blocs/bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/user_data.dart';

class FavoriteButtonBloc extends Bloc {
  final _db = TrailDatabase();
  StreamSubscription _userDataSubscription;

  String _placeId;

  bool isFavorite;

  final _controller = StreamController<bool>();
  Stream<bool> get stream => _controller.stream;

  FavoriteButtonBloc(String placeId) {
    _placeId = placeId;
    if(_db.userData.favorites == null) {
      // This is sometimes a race condition when the user is first being registered
      // To avoid errors, let's set this to false if it cannot find the userData
      isFavorite = false;
    } else {
      isFavorite = _db.userData.favorites.contains(_placeId);
    }    
    _userDataSubscription = _db.userDataStream.listen(_onUserDataUpdate);
  }

  void _onUserDataUpdate(UserData event) {
    var isItNow = _db.userData.favorites.contains(_placeId);
    if(isItNow != isFavorite) {
     isFavorite = _db.userData.favorites.contains(_placeId);
     _controller.sink.add(isFavorite); 
    }    
  }

  void toggleFavorite() {
    List<String> allFavorites = List<String>.from(_db.userData.favorites);
    if(allFavorites.contains(_placeId)) {
      allFavorites.remove(_placeId);      
    } else {
      allFavorites.add(_placeId);
    }
    _db.updateUserData({'favorites': allFavorites});
  }

  @override
  void dispose() {
    _userDataSubscription.cancel();
    _controller.close();
  }

}