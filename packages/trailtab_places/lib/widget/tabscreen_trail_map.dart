// Copyright (c) 2020, Fermented Software.
import 'dart:async';
import 'dart:ui';

import 'package:trail_database/trail_database.dart';
import 'package:trailtab_places/bloc/tabscreen_trail_map_bloc.dart';
import 'package:trailtab_places/widget/map_info_card_carousel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';

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

  Color _buttonColor;

  Color _subHeadingColor;

  ClusterManager<TrailPlace> _manager;

  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = Set();

  TabScreenTrailMapBloc _tabScreenTrailMapBloc = TabScreenTrailMapBloc(TrailDatabase());

  List<ClusterItem<TrailPlace>> items = <ClusterItem<TrailPlace>>[];

  List<TrailPlace> _selectedPlaces = <TrailPlace>[];

  String _selectedMarkerId;

  /// The initial camera position
  static final CameraPosition _geoCenterAlabama = CameraPosition(
    target: LatLng(32.834722222222226, -86.63333333333334),
    zoom: 6.8,
  );

  @override
  void initState() {
    _manager = _initClusterManager();
    items = _tabScreenTrailMapBloc.allTrailPlaces.map((place) {
      return ClusterItem(
        LatLng(place.location.x, place.location.y),
        item: place,
      );
    }).toList();
    _manager.setItems(items);
    _tabScreenTrailMapBloc.allTrailPlaceStream.listen(_onPlaceUpdate);
    super.initState();
  }

  ClusterManager _initClusterManager() {
    return ClusterManager<TrailPlace>(
      items,
      _updateMarkers,
      markerBuilder: _markerBuilder,
      initialZoom: _geoCenterAlabama.zoom,
    );
  }

  void _updateMarkers(Set<Marker> markers) {
    setState(() {
      this._markers = markers;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _buttonColor = Theme.of(context).textTheme.button.color;
    _subHeadingColor = Theme.of(context).textTheme.subtitle1.color;
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          scrollGesturesEnabled: true,
          zoomControlsEnabled: false,
          zoomGesturesEnabled: true,
          mapToolbarEnabled: false,
          myLocationEnabled: true,
          indoorViewEnabled: false,
          onTap: (argument) {
            setState(() {
              _selectedPlaces = null;
              _selectedMarkerId = null;
            });
            _manager.updateMap(); // Forces marker IDs to change
          },
          initialCameraPosition: _geoCenterAlabama,
          markers: _markers,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            _manager.setMapController(controller);
          },
          onCameraMove: _manager.onCameraMove,
          onCameraIdle: _manager.updateMap,
          gestureRecognizers: [
            Factory<OneSequenceGestureRecognizer>(
              () => EagerGestureRecognizer(),
            ),
          ].toSet(),
        ),
        Positioned(
          bottom: 5.0,
          left: 0,
          right: 0,
          child: MapInfoCardCarousel(
            places: _selectedPlaces,
            initialCard: 0,
          ),
        ),
      ],
    );
  }

  Future<Marker> Function(Cluster<TrailPlace>) get _markerBuilder =>
      (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () {
            setState(() {
              _selectedPlaces = cluster.items.toList();
              _selectedMarkerId = cluster.getId();
            });
          },
          icon: await _getMarkerBitmap(cluster.isMultiple ? 125 : 75,
              cluster.getId() == _selectedMarkerId,
              text: cluster.isMultiple ? cluster.count.toString() : null),
        );
      };

  Future<BitmapDescriptor> _getMarkerBitmap(int size, bool isSelected,
      {String text}) async {
    assert(size != null);

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = _buttonColor;
    final Paint multiPaint1 = Paint()..color = _subHeadingColor;
    final Paint paint2 = Paint()..color = Colors.white;
    final Paint paint3 = Paint()
      ..color = _buttonColor; // When selected

    if (text == null) {
      // Null means not multiple
      canvas.drawCircle(
          Offset(size / 2, size / 2), size / 2.0, isSelected ? paint3 : paint1);
      canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
      canvas.drawCircle(
          Offset(size / 2, size / 2), size / 2.8, isSelected ? paint3 : paint1);
    } else {
      canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0,
          isSelected ? paint3 : multiPaint1);
      canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
      canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8,
          isSelected ? paint3 : multiPaint1);
    }

    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
            fontSize: size / 3,
            color: Colors.white,
            fontWeight: FontWeight.normal),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  void _onPlaceUpdate(List<TrailPlace> places) {
    items.clear();
    setState(() {
      items = places.map((place) {
        return ClusterItem(
          LatLng(place.location.x, place.location.y),
          item: place,
        );
      }).toList();
      _manager.setItems(items);
    });
  }
}
