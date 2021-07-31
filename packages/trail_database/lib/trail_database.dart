// Copyright (c) 2020, Fermented Software.
export './domain/beer.dart';
export './domain/check_in.dart';
export './domain/on_tap_beer.dart';
export './domain/trail_event.dart';
export './domain/trail_place.dart';
export './domain/trail_trophy.dart';
export './domain/trail_trophy_any_of_places.dart';
export './domain/trail_trophy_exact_unique_checkins.dart';
export './domain/trail_trophy_total_checkins_any_place.dart';
export './domain/trail_trophy_total_unique_checkins.dart';
export './domain/trail_trophy_unique_pct_of_total.dart';

import 'dart:async';

import 'package:trail_database/domain/beer.dart';
import 'package:trail_database/domain/check_in.dart';
import 'package:trail_database/domain/on_tap_beer.dart';
import 'package:trail_database/domain/trail_event.dart';
import 'package:trail_database/domain/trail_place.dart';
import 'package:trail_database/domain/trail_region.dart';
import 'package:trail_database/domain/trail_trophy.dart';
import 'package:trail_database/domain/user_data.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trail_database/model/check_in.dart';
import 'package:trail_auth/trail_auth.dart';

/// An abstraction to reduce the number of calls to
/// the flutter firestore and to allow easier changing
/// of cloud services.
///
/// This class utilizes a singleton pattern
class TrailDatabase {
  /// Flag to indicate if we already have user
  /// data. This is important in a scenario where
  /// a new user logs in during an app instance and
  /// let's us know if we need to retrieve new data
  bool _knowUserDataExists = false;

  /// Subscription to user data update from Firebase
  StreamSubscription _userDataSubscription;

  /// Subscription to user check ins from Firebase
  StreamSubscription _checkInsSubscription;

  /// The list of events from Firebase
  var events = <TrailEvent>[];

  /// The list of places from Firebase
  var places = <TrailPlace>[];

  /// The list of regions from Firebase
  var regions = <TrailRegion>[];

  /// The list of all trophies from Firebase
  var trophies = <TrailTrophy>[];

  /// The current user's data
  var userData = UserData.createBlank();

  /// The current user's check ins
  var checkIns = <CheckIn>[];

  // Whether to include unpublished objects
  static bool _includeUnPublished = false;

  final _eventsStreamController =
      StreamController<List<TrailEvent>>.broadcast();
  final _placesStreamController =
      StreamController<List<TrailPlace>>.broadcast();
  final _regionsStreamController =
      StreamController<List<TrailRegion>>.broadcast();
  final _trophiesStreamController =
      StreamController<List<TrailTrophy>>.broadcast();
  final _userDataStreamController = StreamController<UserData>.broadcast();
  final _checkInsStreamController = StreamController<List<CheckIn>>.broadcast();

  /// Stream for trail events from the cloud
  Stream<List<TrailEvent>> get eventsStream => _eventsStreamController.stream;

  /// Stream for trail places from the cloud
  Stream<List<TrailPlace>> get placesStream => _placesStreamController.stream;

  /// Stream for the regions from the cloud
  Stream<List<TrailRegion>> get regionsStream =>
      _regionsStreamController.stream;

  /// Stream for trail trophies from the cloud
  Stream<List<TrailTrophy>> get trophiesStream =>
      _trophiesStreamController.stream;

  /// Stream for user data from the cloud
  Stream<UserData> get userDataStream => _userDataStreamController.stream;

  /// Stream for user check ins from the cloud
  Stream<List<CheckIn>> get checkInStream => _checkInsStreamController.stream;

  /// Singleton Pattern
  static final TrailDatabase _singleton = TrailDatabase._internal();

  /// Singleton constructor.
  factory TrailDatabase({bool includeUnpublished = false}) {
    TrailDatabase._includeUnPublished = includeUnpublished;
    return _singleton;
  }

  /// Singleton pattern private constructor.
  TrailDatabase._internal() {
    TrailAuth().onAuthChange.listen((event) {
      _knowUserDataExists = false;
      _subscribeToUserData();
    });

    // We don't need to get a history of events for years, so let's
    // just get up to last week
    int lastWeekTimestampSeconds =
        (DateTime.now().millisecondsSinceEpoch ~/ 1000) - 604800;
    var eventsCollection = FirebaseFirestore.instance.collection('events');
    var publishStates =
        _includeUnPublished ? ['publish', 'draft'] : ['publish'];

    eventsCollection
        .where('publish_status', whereIn: publishStates)
        .where('start_timestamp_seconds',
            isGreaterThanOrEqualTo: lastWeekTimestampSeconds)
        .orderBy('start_timestamp_seconds')
        .snapshots()
        .listen(_onEventsDataUpdate);

    var placesCollection;
    if (_includeUnPublished) {
      placesCollection = FirebaseFirestore.instance.collection('places');
    } else {
      placesCollection = FirebaseFirestore.instance
          .collection('places')
          .where('published', isEqualTo: true);
    }
    placesCollection.snapshots().listen(_onPlacesDataUpdate);

    var regionsCollection;
    if (_includeUnPublished) {
      regionsCollection = FirebaseFirestore.instance.collection('regions');
    } else {
      regionsCollection = FirebaseFirestore.instance
          .collection('regions')
          .where('published', isEqualTo: true);
    }
    regionsCollection.snapshots().listen(_onRegionsUpdate);

    var trophiesCollection;
    if (_includeUnPublished) {
      trophiesCollection = FirebaseFirestore.instance.collection('trophies');
    } else {
      trophiesCollection = FirebaseFirestore.instance
          .collection('trophies')
          .where('published', isEqualTo: true);
    }
    trophiesCollection
        .orderBy('sort_order')
        .snapshots()
        .listen(_onTrophiesDataUpdate);

    _subscribeToUserData();
  }

  /// This gets a little tricky if a new user
  /// is logging into a single app instance or
  /// if the user is logging out
  void _subscribeToUserData() {
    if (_userDataSubscription != null) {
      _userDataSubscription.cancel();
    }
    if (_checkInsSubscription != null) {
      _checkInsSubscription.cancel();
    }
    if (TrailAuth().user != null) {
      _userDataSubscription = FirebaseFirestore.instance
          .collection('user_data')
          .doc(TrailAuth().user.uid)
          .snapshots()
          .listen(_onUserDataUpdate);

      _checkInsSubscription = FirebaseFirestore.instance
          .collection('user_data')
          .doc(TrailAuth().user.uid)
          .collection('check_ins')
          .snapshots()
          .listen(_onCheckInsUpdate);
    } else {
      _onUserDataUpdate(null);
      _onCheckInsUpdate(null);
    }
  }

  /// Handle updates to events data
  void _onEventsDataUpdate(QuerySnapshot snapshot) {
    var newDocs = snapshot.docs;
    var newEvents = <TrailEvent>[];
    newDocs.forEach((d) {
      TrailEvent event = TrailEvent.fromFirebase(d);
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

  /// Handle updates to places data
  void _onPlacesDataUpdate(QuerySnapshot snapshot) {
    var newDocs = snapshot.docs;
    var newPlaces = <TrailPlace>[];
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

  void _onRegionsUpdate(QuerySnapshot snapshot) {
    var newDocs = snapshot.docs;
    var newRegions = <TrailRegion>[];
    newDocs.forEach((r) {
      TrailRegion region = TrailRegion.fromFirebase(r);
      try {
        if (region != null) {
          newRegions.add(region);
        }
      } catch (err) {
        print(err);
      }
    });
    regions = newRegions;
    _regionsStreamController.sink.add(regions);
  }

  /// Handle updates to trophy data
  void _onTrophiesDataUpdate(QuerySnapshot snapshot) {
    var newDocs = snapshot.docs;
    var newTrophies = <TrailTrophy>[];
    newDocs.forEach((d) {
      TrailTrophy trophy = TrailTrophy.fromFirebase(d);
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

  /// Handle updates to user data
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

  /// Handle updates to events data
  void _onCheckInsUpdate(QuerySnapshot snapshot) {
    if (snapshot == null) {
      checkIns = <CheckIn>[];
      _checkInsStreamController.sink.add(checkIns);
    } else {
      var newDocs = snapshot.docs;
      var newCheckIns = <CheckIn>[];
      newDocs.forEach((d) {
        try {
          var data = d.data() as Map<String, dynamic>;
          newCheckIns.add(CheckIn(
              model: CheckInModel(
                  placeId: data['place_id'],
                  timestamp: data['timestamp'].toDate())));
        } catch (err) {
          print(err);
        }
      });

      checkIns = newCheckIns;
      _checkInsStreamController.sink.add(newCheckIns);
    }
  }

  /// Check in to a [placeId]
  Future<void> checkInNow(placeId) {
    return FirebaseFirestore.instance
        .collection('user_data')
        .doc(TrailAuth().user.uid)
        .collection('check_ins')
        .add({
      'place_id': placeId,
      'timestamp': DateTime.now(),
    });
  }

  /// Add the [trophy] for the current user
  void addTrophy(TrailTrophy trophy) {
    var trophyList = userData.trophies;
    if (!trophyList.containsKey(trophy.id)) {
      trophyList[trophy.id] = DateTime.now();
      FirebaseFirestore.instance
          .doc('user_data/${TrailAuth().user.uid}')
          .update({'trophies': trophyList});
    }
  }

  /// Saves the current Firebase Cloud Messaging
  /// [token] for the user.
  ///
  /// This is useful later if we want to send
  /// targeted push notifications
  void saveFcmToken(String token) {
    updateUserData({'fcmToken': token});
  }

  /// Returns the top 25 popular beers from the brewery.
  ///
  /// This is currently tied into Untappd and ranked by
  /// the number of checkins.
  Future<List<Beer>> getPopularBeers(String placeId) {
    return FirebaseFirestore.instance
        .collection('places')
        .doc(placeId)
        .collection('all_beers')
        .get()
        .then((QuerySnapshot snapshot) {
      List<Beer> popularBeers = <Beer>[];
      snapshot.docs.forEach((b) {
        popularBeers.add(Beer.fromFirebase(b));
      });
      this.places.firstWhere((p) => p.id == placeId).allBeers = popularBeers;
      return popularBeers
        ..sort((a, b) => a.untappdRatingCount.compareTo(b.untappdRatingCount));
    });
  }

  /// Returns the current On-Tap list.
  ///
  /// This is currently tied into the Alabama.beer
  /// API service
  Future<List<OnTapBeer>> getTaps(String placeId) {
    return FirebaseFirestore.instance
        .collection('places')
        .doc(placeId)
        .collection('on_tap')
        .get()
        .then((QuerySnapshot snapshot) {
      List<OnTapBeer> taps = <OnTapBeer>[];
      snapshot.docs.forEach((b) {
        taps.add(OnTapBeer.fromFirebase(b));
      });
      this.places.firstWhere((p) => p.id == placeId).onTap = taps;
      return taps..sort((a, b) => a.name.compareTo(b.name));
    });
  }

  /// Update user's data. If the user does not have
  /// data in the cloud, it will create a blank entry
  void updateUserData(Object data) {
    if (_knowUserDataExists) {
      _doUserDataUpdate(data);
    } else {
      var userDataCollection =
          FirebaseFirestore.instance.collection('user_data');
      userDataCollection.doc(TrailAuth().user.uid).get().then((value) {
        if (value.exists) {
          _knowUserDataExists = true;
          _doUserDataUpdate(data);
        } else {
          userDataCollection
              .doc(TrailAuth().user.uid)
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
        .doc(TrailAuth().user.uid)
        .update(data);
  }

  void updatePlace(String id, Map<String, dynamic> data) {
    FirebaseFirestore.instance.collection('places').doc(id).update(data);
  }

  void dispose() {
    _eventsStreamController.close();
    _placesStreamController.close();
    _regionsStreamController.close();
    _trophiesStreamController.close();
    _userDataStreamController.close();
    _checkInsStreamController.close();
  }
}
