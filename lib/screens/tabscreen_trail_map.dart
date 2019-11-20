import 'dart:async';

import 'package:alabama_beer_trail/blocs/trail_places_bloc.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/screens/screen_trailplace_detail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  
  /// The Google Map controller
  Completer<GoogleMapController> _controller = Completer();

  /// The BloC for the trail places
  TrailPlacesBloc _trailPlacesBloc = TrailPlacesBloc();

  /// The markers to show on the map
  Set<Marker> _markers = Set<Marker>();

  /// The initial camera position
  static final CameraPosition _geoCenterAlabama = CameraPosition(
    target: LatLng(32.834722222222226, -86.63333333333334),
    zoom: 6.8,
  );

  @override
  void initState() {
    super.initState();
    _trailPlacesBloc.trailPlaceStream.listen(_onPlaceUpdate);
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
      initialCameraPosition: _geoCenterAlabama,
      markers: _markers,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      gestureRecognizers: [
        Factory<OneSequenceGestureRecognizer>(
          () => EagerGestureRecognizer(),
        ),
      ].toSet(),
    );
  }

  /// Called on an update to the trail places
  /// 
  /// Draws the markers on the map.
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
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            infoWindow: InfoWindow(
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
                          builder: (context) =>
                              TrailPlaceDetailScreen(place: p)));
                }),
          ),
        );
      });
    });
  }

  @override
  bool get wantKeepAlive => true;
}
