import 'dart:async';

import 'package:alabama_beer_trail/data/trail_trophy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'bloc.dart';

class TrailTrophyBloc extends Bloc {
  TrailTrophyBloc() {
    Firestore.instance.collection('trophies/')
      .where('published', isEqualTo: true)
      .snapshots()
      .listen(_onDataUpdate);
  }

  List<TrailTrophy> trailTrophies = List<TrailTrophy>();
  final _trailTrophiesController = StreamController<List<TrailTrophy>>();
  Stream<List<TrailTrophy>> get trailTrophiesStream =>
      _trailTrophiesController.stream;

  void _onDataUpdate(QuerySnapshot querySnapshot) {
    var newDocs = querySnapshot.documents;

    List<TrailTrophy> newTrailTrophies = List<TrailTrophy>();
    newDocs.forEach((d) {
      try {
        newTrailTrophies.add(
          TrailTrophy.createFromFirebase(d)
        );
      } catch (e) {
        print(e);
      }
    });
    this.trailTrophies = newTrailTrophies;
    this._trailTrophiesController.sink.add(this.trailTrophies);
  }

  @override
  void dispose() {
    _trailTrophiesController.close();
  }
}
