// Copyright (c) 2020, Fermented Software.
import 'dart:async';

import 'package:alabama_beer_trail/data/check_in.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';

import 'bloc.dart';

/// The BLoC for TrailProgressBar objects
class TrailProgressBarBloc extends Bloc {
  /// A reference to the central database
  TrailDatabase _db;

  /// The current user's checkins
  List<CheckIn> _checkIns;

  /// The current list of places
  List<TrailPlace> _places;

  /// The user's progress information
  ProgressInformation progressInformation;

  /// A subscription to the trail places
  StreamSubscription _placesSubscription;

  // A subscription to the user's checkins
  StreamSubscription _checkInsSubscription;

  /// Controller for this BLoC's progress information stream
  final _progressInformationStreamController = StreamController<ProgressInformation>();

  /// The stream for this BLoC's ProgressInformation
  get stream => _progressInformationStreamController.stream;

  /// Constructor
  TrailProgressBarBloc(TrailDatabase db) {
    _db = db;
    _checkIns = _db.checkIns;
    _places = _db.places;
    _placesSubscription = _db.placesStream.listen(_onPlacesUpdate);
    _checkInsSubscription = _db.checkInStream.listen(_onCheckInsUpdate);
    progressInformation = _buildProgressStreamData(_checkIns, _places);
  }

  /// Build the progress information data for the stream
  ProgressInformation _buildProgressStreamData(List<CheckIn> checkIns, List<TrailPlace> places) {
     return ProgressInformation(_db.checkIns.map((c) => c.placeId).toSet().length, _db.places.length);
  }

  /// Callback when check in data is updated
  void _onCheckInsUpdate(List<CheckIn> checkIns) {
    _checkIns = checkIns;
    progressInformation = _buildProgressStreamData(_checkIns, _places);
    _progressInformationStreamController.add(progressInformation);
  }

  /// Callback when places data is updated
  void _onPlacesUpdate(List<TrailPlace> places) {
    _places = places;
    progressInformation = _buildProgressStreamData(_checkIns, _places);
    _progressInformationStreamController.add(progressInformation);
  }

  /// Dispose object
  @override
  void dispose() {
    _checkInsSubscription.cancel();
    _placesSubscription.cancel();
  }

}

/// The user's trail progress, including
class ProgressInformation {
  /// The number of unique checkins (how many places visited)
  final int uniqueCheckIns;

  /// The number of total places available for check in
  final int totalPlaces;

  /// The percent complete that is derived from [uniqueCheckIns]
  /// and [totalPlaces]
  double get percentProgress {
    return uniqueCheckIns / totalPlaces.toDouble();
  }

  /// Constructor
  ProgressInformation(this.uniqueCheckIns, this.totalPlaces);
  
}