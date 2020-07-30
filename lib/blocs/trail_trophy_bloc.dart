import 'dart:async';

import 'package:alabama_beer_trail/data/check_in.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/data/trail_trophy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'bloc.dart';

class TrailTrophyBloc extends Bloc {
  TrailTrophyBloc() {
    Firestore.instance
        .collection('trophies/')
        .where('published', isEqualTo: true)
        .snapshots()
        .listen(_onDataUpdate);    
  }

  List<TrailTrophy> trailTrophies = List<TrailTrophy>();
  final _trailTrophiesController = StreamController<List<TrailTrophy>>.broadcast();
  Stream<List<TrailTrophy>> get trailTrophiesStream =>
      _trailTrophiesController.stream;

  void _onDataUpdate(QuerySnapshot querySnapshot) {
    var newDocs = querySnapshot.documents;

    List<TrailTrophy> newTrailTrophies = List<TrailTrophy>();
    newDocs.forEach((d) {
      try {
        var trophy = TrailTrophy.createFromFirebase(d);
        if(trophy != null) {
          newTrailTrophies.add(TrailTrophy.createFromFirebase(d));
          this.trailTrophies = newTrailTrophies;
          this._trailTrophiesController.sink.add(this.trailTrophies);
        }        
      } catch (e) {
        print(e);
      }
    });
  }

  List<TrailTrophy> getNewTrophies(List<CheckIn> allCheckIns,
      List<TrailPlace> trailPlaces, List<String> currentTrophiesIds) {
    var newTrophies = List<TrailTrophy>();

    this.trailTrophies.forEach((trophy) {
      if (trophy.conditionsMet(allCheckIns, trailPlaces) &&
          !currentTrophiesIds.contains(trophy.id)) {
        newTrophies.add(trophy);
      }
    });

    return newTrophies;
  }

  @override
  void dispose() {
    _trailTrophiesController.close();
  }
}
