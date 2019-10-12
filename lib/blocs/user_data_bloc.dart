import 'dart:async';
import '../util/appauth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'bloc.dart';

class UserDataBloc implements Bloc {
  UserDataBloc() {
    Firestore.instance.document('user_data/${AppAuth().user.uid}').snapshots().listen(_onDataUpdate);
    this.userData['favorites'] = List<String>();
  }

  var userData = Map<String, dynamic>();
  final _userDataController = StreamController<Map<String, dynamic>>();
  Stream<Map<String, dynamic>> get userDataStream  => _userDataController.stream;  

  void _onDataUpdate(DocumentSnapshot documentSnapshot) {
    var newData = documentSnapshot.data;
    this.userData = newData;
    this._userDataController.sink.add(this.userData);
  }

  void toggleFavorite(String placeId) {
    List<String> favorites = List<String>.from(this.userData['favorites']);
    if(favorites.contains(placeId)) {
      favorites.remove(placeId);
    } else {
      favorites.add(placeId);
    }
    Firestore.instance.collection('user_data').document(AppAuth().user.uid).updateData(
      {'favorites': favorites});
  }

  @override
  void dispose() {
    _userDataController.close();
  }  
}