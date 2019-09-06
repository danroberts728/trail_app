import 'dart:async';
import 'package:alabama_beer_trail/util/appauth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'bloc.dart';

class UserDataBloc implements Bloc {
  UserDataBloc() {
    Firestore.instance.document('user_data/${AppAuth().user.uid}').snapshots().listen(_onDataUpdate);
    Firestore.instance.collection('user_data/${AppAuth().user.uid}/check_ins').reference().snapshots().listen(_onCheckinUpdate);
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

  void _onCheckinUpdate(QuerySnapshot querySnapshot) {
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);
    var newDocs = querySnapshot.documents..removeWhere((doc) => today.isAfter(DateTime.fromMillisecondsSinceEpoch(doc.data['timestamp'].millisecondsSinceEpoch)));

    List<String> newCheckIns = List<String>();
    newDocs.forEach((e) => newCheckIns.add(e.data['place_id']));
    _checkInsController.sink.add(newCheckIns);
  }

  List<String> newCheckIns = List<String>(); 
  final _checkInsController = StreamController<List<String>>();
  Stream<List<String>> get checkInStream => _checkInsController.stream;

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

  void checkIn(String placeId) {
    if(!newCheckIns.contains(placeId)) {
      // Only update if user has not checked in today already
      Firestore.instance.collection('user_data/${AppAuth().user.uid}/check_ins').add(
      {
        'place_id': placeId,
        'timestamp': DateTime.now(),
      });
    }
  }

  @override
  void dispose() {
    _favoriteController.close();
    _checkInsController.close();
  }  
}