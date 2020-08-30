import 'dart:async';
import 'package:alabama_beer_trail/util/appauth.dart';
import 'package:alabama_beer_trail/data/check_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'bloc.dart';

class UserCheckinsBloc implements Bloc {
  UserCheckinsBloc() {
    FirebaseFirestore.instance
        .collection('user_data/${AppAuth().user.uid}/check_ins')
        .snapshots()
        .listen(_onCheckinUpdate);
  }

  List<CheckIn> checkIns = List<CheckIn>();
  final _checkInsController = StreamController<List<CheckIn>>.broadcast();
  Stream<List<CheckIn>> get checkInStream =>
      _checkInsController.stream;

  void _onCheckinUpdate(QuerySnapshot querySnapshot) {
    var newDocs = querySnapshot.docs;

    List<CheckIn> newCheckIns = List<CheckIn>();
    newDocs.forEach((e) => newCheckIns.add(CheckIn(
        e.data()['place_id'], (e.data()['timestamp'] as Timestamp).toDate())));
    this.checkIns = newCheckIns;
    _checkInsController.sink.add(this.checkIns);
  }

  bool checkIn(String placeId) {
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);

    // Get today's checkins
    List<CheckIn> todaysCheckins = this
        .checkIns
        .where((e) =>
            DateTime(e.timestamp.year, e.timestamp.month, e.timestamp.day) ==
            today)
        .toList();

    // Only update if user has not checked in today already
    if (todaysCheckins.where((e) => e.placeId == placeId).length == 0) {
      FirebaseFirestore.instance
          .collection('user_data/${AppAuth().user.uid}/check_ins')
          .add({
        'place_id': placeId,
        'timestamp': DateTime.now(),
      });
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    _checkInsController.close();
  }
}
