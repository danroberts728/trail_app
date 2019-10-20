import 'package:alabama_beer_trail/blocs/location_bloc.dart';
import 'package:alabama_beer_trail/blocs/trail_places_bloc.dart';
import 'package:alabama_beer_trail/util/geomethods.dart';
import 'package:alabama_beer_trail/widgets/trail_listview.dart';

import '../util/filteroptions.dart';
import 'tabscreen_child.dart';
import 'package:flutter/material.dart';
import '../data/trailplace.dart';
import '../widgets/modal_trailfilter.dart';

class TabScreenTrail extends StatefulWidget implements TabScreenChild {
  final _TabScreenTrail _state = _TabScreenTrail();

  @override
  State<StatefulWidget> createState() => _state;

  List<IconButton> getAppBarActions() {
    return _state.getAppBarActions();
  }
}

class _TabScreenTrail extends State<TabScreenTrail>
    with AutomaticKeepAliveClientMixin<TabScreenTrail> {
  FilterOptions _filterOptions;
  var _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  var _places = List<TrailPlace>();
  var _sortMethod = SortMethod.DISTANCE;

  Widget _refreshChildWidget = CircularProgressIndicator();

  var _trailPlacesBloc = TrailPlacesBloc();
  var _locationBloc = LocationBloc();

  /// Build screen when location data received
  _TabScreenTrail();

  @override
  void initState() {
    _locationBloc.locationStream.listen((newLocation) {
      _refreshPlaces();
    });
    _trailPlacesBloc.trailPlaceStream.listen((newPlaces) {
      this._places = newPlaces;
      _refreshPlaces();
    });
    super.initState();
  }

  void _refreshPlaces() {
    setState(() {
      this._refreshChildWidget = Center(child: CircularProgressIndicator());
    });

    sortPlaces();

    // We have to delay the setState to "trick" Flutter
    // into actually disposing and regenerating the listview
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _refreshChildWidget = TrailListView(places: this._places);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      key: this._refreshIndicatorKey,
      onRefresh: () => _locationBloc.refreshLocation(),
      child: _refreshChildWidget,
    );
  }

  void sortPlaces() {
    if (this._sortMethod == SortMethod.DISTANCE &&
        _locationBloc.hasPermission) {
      this._places.sort((a, b) {
        return GeoMethods.calculateDistance(
                a.location, _locationBloc.lastLocation)
            .compareTo(GeoMethods.calculateDistance(
                b.location, _locationBloc.lastLocation));
      });
    } else {
      this._places.sort((a, b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    }
  }

  List<IconButton> getAppBarActions() {
    return <IconButton>[
      IconButton(
        icon: Icon(Icons.refresh),
        onPressed: () {
          this._refreshIndicatorKey.currentState.show();
        },
      ),
      IconButton(
        icon: Icon(Icons.filter_list),
        onPressed: filterPressed,
      ),
    ];
  }

  void filterPressed() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ModalTrailFilter(initialOptions: this._filterOptions);
      },
    ).then((value) {
      this._filterOptions = value;
      this._refreshIndicatorKey.currentState.show().then((value) {
        return _locationBloc.refreshLocation();
      });
    });
  }

  @override
  bool get wantKeepAlive => true;

  /*void _updateDistancesWithLastLocation() {
    Point p = CurrentUserLocation().lastLocation;
    this._places.forEach((element) =>
        element.lastClaculatedDistance = element.calculateDistance(p));
  }

  void _sortPlaces() {
    if (_filterOptions.sort == SortOrder.DISTANCE &&
        CurrentUserLocation().hasPermission)
      sortPlacesByDistance();
    else
      sortPlacesByName();
  }*/
}

enum SortMethod { DISTANCE, NAME }
