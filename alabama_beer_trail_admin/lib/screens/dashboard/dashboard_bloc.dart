import 'dart:async';

import 'package:trail_database/trail_database.dart';

class DashboardBloc {
  TrailDatabase _db = TrailDatabase();
  DashboardData dashboardData = DashboardData(
    totalPlacesCount: 0,
    publishedPlacesCount: 0,
    unpublishedPlacesCount: 0,
  );

  StreamSubscription _placesSubscription;

  DashboardBloc() {
    dashboardData = DashboardData(
      totalPlacesCount: _db.places.length,
      publishedPlacesCount: _db.places.where((p) => p.published).length,
      unpublishedPlacesCount: _db.places.where((p) => !p.published).length,
    );
    _placesSubscription = _db.placesStream.listen(_onPlacesUpdate);
  }

  final _streamController = StreamController<DashboardData>();
  Stream<DashboardData> get stream => _streamController.stream;

  void _onPlacesUpdate(List<TrailPlace> places) {
    _updateAndSendStream(
      numberOfPlaces: places.length,
      publishedCount: places.where((p) => p.published).length,
      unpublishedCount: places.where((p) => !p.published).length,
    );
  }

  void _updateAndSendStream(
      {int numberOfPlaces, int publishedCount, int unpublishedCount}) {
    dashboardData = DashboardData(
      totalPlacesCount: numberOfPlaces,
      publishedPlacesCount: publishedCount,
      unpublishedPlacesCount: unpublishedCount,
    );
    _streamController.add(dashboardData);
  }

  dispose() {
    _placesSubscription.cancel();
    _streamController.close();
  }
}

class DashboardData {
  final int totalPlacesCount;
  final int publishedPlacesCount;
  final int unpublishedPlacesCount;

  DashboardData(
      {this.publishedPlacesCount,
      this.unpublishedPlacesCount,
      this.totalPlacesCount});
}
