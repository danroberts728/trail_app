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

  final _newTrophiesController =
      StreamController<List<TrailTrophy>>.broadcast();
  Stream<List<TrailTrophy>> get newTrophiesStream =>
      _newTrophiesController.stream;

  void _onCheckinUpdate(QuerySnapshot querySnapshot) {
    Future.microtask(() {
      List<CheckIn> allCheckIns = List<CheckIn>();
      var newDocs = querySnapshot.documents;
      newDocs.forEach((e) {
        allCheckIns.add(CheckIn(
            e.data['place_id'], (e.data['timestamp'] as Timestamp).toDate()));
      });
      return allCheckIns;
    }).then((allCheckIns) {
      var trailPlaces = _trailPlacesBloc.trailPlaces;
      var currentTrophies = _userDataBloc.userData.trophies;

      var newTrophies = _trailTrophyBloc.getNewTrophies(
          allCheckIns, trailPlaces, currentTrophies == null
            ? List<String>()
            : currentTrophies.keys.toList());

      for (var trophy in newTrophies) {
        currentTrophies[trophy.id] = DateTime.now();
      }

      Firestore.instance
          .collection('user_data')
          .document(AppAuth().user.uid)
          .updateData({'trophies': currentTrophies});

      return newTrophies;
    }).then((newTrophies) {
      _newTrophiesController.sink.add(newTrophies);
    });
  }

  @override
  void dispose() {
    _newTrophiesController.close();
  }
}
