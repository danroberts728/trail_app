import 'dart:async';

import 'package:alabama_beer_trail/blocs/trail_places_bloc.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/screens/screen_trailplace_detail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:clustering_google_maps/clustering_google_maps.dart';

/// The trail map screen
///
/// This is a sub-screen for the Trail Tab
class TabScreenTrailMap extends StatefulWidget {
  @override
  State<TabScreenTrailMap> createState() => _TabScreenTrailMap();
}

/// The state of the trail map screen
///
class _TabScreenTrailMap extends State<TabScreenTrailMap>
    with AutomaticKeepAliveClientMixin<TabScreenTrailMap> {
  
  @override
  bool get wantKeepAlive => true;
  
  /// The Google Map controller
  Completer<GoogleMapController> _controller = Completer();

  /// Clustering Helper
  ClusteringHelper _clusteringHelper;

  /// The BloC for the trail places
  TrailPlacesBloc _trailPlacesBloc = TrailPlacesBloc();

  /// The markers to show on the map
  Set<Marker> _markers = Set<Marker>();

  /// The initial camera position
  static final CameraPosition _geoCenterAlabama = CameraPosition(
    target: LatLng(32.834722222222226, -86.63333333333334),
    zoom: 6.8,
  );

  /// The current camera position.
  ///
  /// Defaults to [_geoCenterAlabama] const
  var _currentPosition = _geoCenterAlabama;

  @override
  void initState() {
    super.initState();
    _trailPlacesBloc.trailPlaceStream.listen(_onPlaceUpdate);
    _clusteringHelper = ClusteringHelper.forMemory(
      list: _convertMarkersForCluster(_markers),
      maxZoomForAggregatePoints: 13.5,
      updateMarkers: _updateMarkers,
      aggregationSetup: AggregationSetup(
        markerSize: 175,
        colors: const [
          Colors.lightBlue,
          Colors.lightBlue,
          Colors.lightBlue,
          Colors.lightBlue,
          Colors.lightBlue,
          Colors.lightBlue,
          Colors.lightBlue,
        ],
      ),
    );
    _clusteringHelper.showSinglePoint =
        _updatePointsPastMaxZoomForAggregatePoints;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GoogleMap(
      mapType: MapType.normal,
      scrollGesturesEnabled: true,
      zoomGesturesEnabled: true,
      mapToolbarEnabled: true,
      myLocationEnabled: true,
      indoorViewEnabled: false,
      initialCameraPosition: _currentPosition,
      markers: _markers,
      onMapCreated: (GoogleMapController controller) {
        _onMapCreated(controller);
      },
      onCameraMove: (newPosition) {
        _currentPosition = newPosition;
        _clusteringHelper.onCameraMove(newPosition, forceUpdate: false);
      },
      onCameraIdle: () {
        _clusteringHelper.onMapIdle();
      },
      gestureRecognizers: [
        Factory<OneSequenceGestureRecognizer>(
          () => EagerGestureRecognizer(),
        ),
      ].toSet(),
    );
  }

  /// Called when the Google Map is created
  ///
  void _onMapCreated(GoogleMapController mapController) {
    _controller.complete(mapController);
    _clusteringHelper.mapController = mapController;
  }

  /// Called on an update to the trail places
  ///
  /// Draws the markers on the map, including any
  /// clusters
  void _onPlaceUpdate(List<TrailPlace> places) {
    _markers.clear();
    setState(() {
      places.forEach((p) {
        _markers.add(
          Marker(
            markerId: MarkerId(p.id),
            position: LatLng(
              p.location.x,
              p.location.y,
            ),
          ),
        );
      });
    });
    _clusteringHelper.updateData(_convertMarkersForCluster(_markers));
    _clusteringHelper.onCameraMove(_currentPosition, forceUpdate: false);
  }

  /// Converts markers to a LatLngAndGeoHash object for clustering
  ///
  List<LatLngAndGeohash> _convertMarkersForCluster(Set<Marker> markers) {
    return _markers
        .map((m) =>
            LatLngAndGeohash(LatLng(m.position.latitude, m.position.longitude)))
        .toList();
  }

  /// Returns an appropriate info window for a single marker
  ///
  /// Compares to the [lat] and [lng] because clustering
  /// hides the actual place object.
  InfoWindow _getSingleInfoWindow(double lat, double lng) {
    TrailPlace p = _trailPlacesBloc.trailPlaces
        .firstWhere((a) => a.location.x == lat && a.location.y == lng);
    return InfoWindow(
        title: p.name,
        snippet: (p.categories..sort()).join(", "),
        onTap: () {
          Feedback.forTap(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  settings: RouteSettings(
                    name: 'Trail Place - ' + p.name,
                  ),
                  builder: (context) => TrailPlaceDetailScreen(place: p)));
        });
  }

  /// Returns an appropriate info window for a cluster
  ///
  /// The default for clustering is for the title to
  /// simply be the number of objects in the cluster.
  /// This method gives more information.
  InfoWindow _getClusterInfoWindow(Marker item) {
    var clusterCount = item.infoWindow.title;
    return InfoWindow(
        title: "Multiple Locations ($clusterCount)",
        snippet: "Zoom in to see more.",
        onTap: () {
          _clusteringHelper.mapController.animateCamera(CameraUpdate.zoomIn());
        });
  }

  /// Update the points when the map is zoomed beyond
  /// maxZoomForAggregatePoints
  ///
  /// This overrides the clustering helper's draw of
  /// points because it is buggy and closes the info
  /// window after the user opens it up.
  _updatePointsPastMaxZoomForAggregatePoints() async {
    _markers.clear();
    var places = _trailPlacesBloc.trailPlaces;
    setState(() {
      places.forEach((p) {
        _markers.add(
          Marker(
              markerId: MarkerId(p.id),
              position: LatLng(
                p.location.x,
                p.location.y,
              ),
              icon: BitmapDescriptor.defaultMarker,
              infoWindow: _getSingleInfoWindow(p.location.x, p.location.y)),
        );
      });
    });
  }

  /// Update the markers to show the info Window
  ///
  /// This is called after the clustering helper redraws the
  /// markers to show clusters. The main function is to redraw
  /// the info window to show better information.
  ///
  /// Note that this is not called when the map is zoomed-in
  /// beyond the maxZoomForAggregatePoints
  void _updateMarkers(Set<Marker> markers) {
    setState(() {
      this._markers = markers.map((item) {
        if (int.tryParse(item.infoWindow.title) == null) {
          return item.copyWith(
            infoWindowParam: _getSingleInfoWindow(
                item.position.latitude, item.position.longitude),
          );
        } else if (item.infoWindow.title == "1") {
          return item.copyWith(
            infoWindowParam: _getSingleInfoWindow(
                item.position.latitude, item.position.longitude),
          );
        } else {
          return item.copyWith(
            infoWindowParam: _getClusterInfoWindow(item),
          );
        }
      }).toSet();
    });
  }
}
