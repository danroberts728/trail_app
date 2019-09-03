import 'dart:async';
import 'package:alabama_beer_trail/util/appauth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'bloc.dart';

class UserDataBloc implements Bloc {
  UserDataBloc() {
    Firestore.instance.document('user_data/${AppAuth().user.uid}').snapshots().listen(_onDataUpdate);
  }

  void _onDataUpdate(DocumentSnapshot documentSnapshot) {
    var newData = documentSnapshot.data;

    // Favorites
    List<String> newFavorites = List<String>();
    newData['favorites'].forEach((e) => newFavorites.add(e));
    if(this.favorites.length != newFavorites.length) {
      this.favorites = newFavorites;
      _favoriteController.sink.add(this.favorites);
    }
  }

  List<String> favorites = List<String>();

  final _favoriteController = StreamController<List<String>>();
  Stream<List<String>> get favoriteStream => _favoriteController.stream;

  void toggleFavorite(String placeId) {
    if(favorites.contains(placeId)) {
      favorites.remove(placeId);
    } else {
      favorites.add(placeId);
    }
    Firestore.instance.collection('user_data').document(AppAuth().user.uid).updateData(
      {'favorites': this.favorites});
  }

  @override
  void dispose() {
    _favoriteController.close();
  }  
}