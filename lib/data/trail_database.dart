import 'dart:async';

import 'package:alabama_beer_trail/data/check_in.dart';
import 'package:alabama_beer_trail/data/trail_event.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/data/trail_trophy.dart';
import 'package:alabama_beer_trail/data/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alabama_beer_trail/util/appauth.dart';

/// An abstraction to reduce the number of calls to
/// the flutter firestore
class TrailDatabase {
  bool _knowUserDataExists = false;

  StreamSubscription _userDataSubscription;
  StreamSubscription _checkInsSubscription;

  var events = List<TrailEvent>();
  var places = List<TrailPlace>();
  var trophies = List<TrailTrophy>();

  var userData = UserData.createBlank();
  var checkIns = List<CheckIn>();

  final _eventsStreamController =
      StreamController<List<TrailEvent>>.broadcast();
  final _placesStreamController =
      StreamController<List<TrailPlace>>.broadcast();
  final _trophiesStreamController =
      StreamController<List<TrailTrophy>>.broadcast();
  final _userDataStreamController = StreamController<UserData>.broadcast();
  final _checkInsStreamController = StreamController<List<CheckIn>>.broadcast();

  Stream<List<TrailEvent>> get eventsStream => _eventsStreamController.stream;
  Stream<List<TrailPlace>> get placesStream => _placesStreamController.stream;
  Stream<List<TrailTrophy>> get trophiesStream =>
      _trophiesStreamController.stream;
  Stream<UserData> get userDataStream => _userDataStreamController.stream;
  Stream<List<CheckIn>> get checkInStream => _checkInsStreamController.stream;

  /// Singleton Pattern
  static final TrailDatabase _singleton = TrailDatabase._internal();

  /// Singleton constructor.
  factory TrailDatabase() {
    return _singleton;
  }

  /// Singleton pattern private constructor.
  TrailDatabase._internal() {
    AppAuth().onAuthChange.listen((event) {
      _knowUserDataExists = false;
      _subscribeToUserData();
    });

    int lastWeekTimestampSeconds =
        (DateTime.now().millisecondsSinceEpoch ~/ 1000) - 604800;
    FirebaseFirestore.instance
        .collection('events')
        .where('publish_status', isEqualTo: 'publish')
        .where('start_timestamp_seconds',
            isGreaterThanOrEqualTo: lastWeekTimestampSeconds)
        .orderBy('start_timestamp_seconds')
        .snapshots()
        .listen(_onEventsDataUpdate);

    FirebaseFirestore.instance
        .collection('places')
        .where('published', isEqualTo: true)
        .snapshots()
        .listen(_onPlacesDataUpdate);

    FirebaseFirestore.instance
        .collection('trophies')
        .where('published', isEqualTo: true)
        .orderBy('sort_order')
        .snapshots()
        .listen(_onTrophiesDataUpdate);

    _subscribeToUserData();
  }

  void _subscribeToUserData() {
    if (_userDataSubscription != null) {
      _userDataSubscription.cancel();
    }
    if (_checkInsSubscription != null) {
      _checkInsSubscription.cancel();
    }
    if (AppAuth().user != null) {
      _userDataSubscription = FirebaseFirestore.instance
          .collection('user_data')
          .doc(AppAuth().user.uid)
          .snapshots()
          .listen(_onUserDataUpdate);

      _checkInsSubscription = FirebaseFirestore.instance
          .collection('user_data')
          .doc(AppAuth().user.uid)
          .collection('check_ins')
          .snapshots()
          .listen(_onCheckInsUpdate);
    } else {
      _onUserDataUpdate(null);
      _onCheckInsUpdate(null);
    }
  }

  void _onEventsDataUpdate(QuerySnapshot snapshot) {
    var newDocs = snapshot.docs;
    var newEvents = List<TrailEvent>();
    newDocs.forEach((d) {
      TrailEvent event = TrailEvent.buildFromFirebase(d);
      try {
        if (event != null) {
          newEvents.add(event);
        }
      } catch (err) {
        print(err);
      }
    });
    events = newEvents;
    _eventsStreamController.sink.add(newEvents);
  }

  void _onPlacesDataUpdate(QuerySnapshot snapshot) {
    var newDocs = snapshot.docs;
    var newPlaces = List<TrailPlace>();
    newDocs.forEach((d) {
      TrailPlace place = TrailPlace.createFromFirebase(d);
      try {
        if (place != null) {
          newPlaces.add(place);
        }
      } catch (err) {
        print(err);
      }
    });
    places = newPlaces;
    _placesStreamController.sink.add(newPlaces);
  }

  void _onTrophiesDataUpdate(QuerySnapshot snapshot) {
    var newDocs = snapshot.docs;
    var newTrophies = List<TrailTrophy>();
    newDocs.forEach((d) {
      TrailTrophy trophy = TrailTrophy.createFromFirebase(d);
      try {
        if (trophy != null) {
          newTrophies.add(trophy);
        }
      } catch (err) {
        print(err);
      }
    });
    trophies = newTrophies;
    _trophiesStreamController.sink.add(newTrophies);
  }

  void _onUserDataUpdate(DocumentSnapshot snapshot) {
    if (snapshot == null || snapshot.data() == null) {
      userData = UserData.createBlank();
      _userDataStreamController.sink.add(userData);
    } else {
      var newUserData = UserData.fromFirebase(snapshot);
      userData = newUserData;
      _userDataStreamController.sink.add(newUserData);
    }
  }

  void _onCheckInsUpdate(QuerySnapshot snapshot) {
    if (snapshot == null) {
      checkIns = List<CheckIn>();
      _checkInsStreamController.sink.add(checkIns);
    } else {
      var newDocs = snapshot.docs;
      var newCheckIns = List<CheckIn>();
      newDocs.forEach((d) {
        try {
          var data = d.data();
          newCheckIns
              .add(CheckIn(data['place_id'], data['timestamp'].toDate()));
        } catch (err) {
          print(err);
        }
      });

      checkIns = newCheckIns;
      _checkInsStreamController.sink.add(newCheckIns);
    }
  }

  Future<void> checkInNow(placeId) {
    return FirebaseFirestore.instance
        .collection('user_data')
        .doc(AppAuth().user.uid)
        .collection('check_ins')
        .add({
      'place_id': placeId,
      'timestamp': DateTime.now(),
    });
  }

  void addTrophy(TrailTrophy trophy) {
    var trophyList = userData.trophies;
    if (!trophyList.containsKey(trophy.id)) {
      trophyList[trophy.id] = DateTime.now();
      FirebaseFirestore.instance
          .doc('user_data/${AppAuth().user.uid}')
          .update({'trophies': trophyList});
    }
  }

  void saveFcmToken(String token) {
    updateUserData({'fcmToken': token});
  }

  void updateUserData(Object data) {
    if (_knowUserDataExists) {
      _doUserDataUpdate(data);
    } else {
      var userDataCollection =
          FirebaseFirestore.instance.collection('user_data');
      userDataCollection.doc(AppAuth().user.uid).get().then((value) {
        if (value.exists) {
          _knowUserDataExists = true;
          _doUserDataUpdate(data);
        } else {
          userDataCollection
              .doc(AppAuth().user.uid)
              .set(UserData.createBlank().toMap())
              .then((value) {
            _knowUserDataExists = true;
            _doUserDataUpdate(data);
          });
        }
      });
    }
  }

  void _doUserDataUpdate(Object data) {
    FirebaseFirestore.instance
        .collection('user_data')
        .doc(AppAuth().user.uid)
        .update(data);
  }

  void dispose() {
    _eventsStreamController.close();
    _placesStreamController.close();
    _trophiesStreamController.close();
    _userDataStreamController.close();
    _checkInsStreamController.close();
  }
}
