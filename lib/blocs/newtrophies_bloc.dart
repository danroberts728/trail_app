import 'dart:async';

import 'package:alabama_beer_trail/blocs/appauth_bloc.dart';
import 'package:alabama_beer_trail/blocs/bloc.dart';
import 'package:alabama_beer_trail/blocs/trail_places_bloc.dart';
import 'package:alabama_beer_trail/blocs/trail_trophy_bloc.dart';
import 'package:alabama_beer_trail/blocs/user_data_bloc.dart';
import 'package:alabama_beer_trail/data/check_in.dart';
import 'package:alabama_beer_trail/data/trail_trophy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewTrophyBloc extends Bloc {
  NewTrophyBloc() {
    Firestore.instance
        .collection('user_data/${AppAuth().user.uid}/check_ins')
        .reference()
        .snapshots()
        .listen(_onCheckinUpdate);
  }

  TrailPlacesBloc _trailPlacesBloc = TrailPlacesBloc();

  TrailTrophyBloc _trailTrophyBloc = TrailTrophyBloc();  

  UserDataBloc _userDataBloc = UserDataBloc();

  final _newTrophiesController = StreamController<List<TrailTrophy>>.broadcast();
  Stream<List<TrailTrophy>> get newTrophiesStream =>
      _newTrophiesController.stream;

  void _onCheckinUpdate(QuerySnapshot querySnapshot) {
    List<CheckIn> allCheckIns = List<CheckIn>();
    var newDocs = querySnapshot.documents;
    newDocs.forEach((e) {
      allCheckIns.add(CheckIn(e.data['place_id'], (e.data['timestamp'] as Timestamp).toDate() ));
    });
    

    var trailPlaces = _trailPlacesBloc.trailPlaces;

    var currentTrophies = _userDataBloc.userData.trophies;

    List<TrailTrophy> newTrophies = _trailTrophyBloc.getNewTrophies(allCheckIns, trailPlaces, currentTrophies);

    for(var trophy in newTrophies) {
      currentTrophies.add(trophy.id);
    }

    Firestore.instance
        .collection('user_data')
        .document(AppAuth().user.uid)
        .updateData({'trophies': currentTrophies});    

    _newTrophiesController.sink.add(newTrophies);

  }

  @override
  void dispose() {
    _newTrophiesController.close();
  }  
}
