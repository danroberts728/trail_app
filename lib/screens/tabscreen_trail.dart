import 'package:alabama_beer_trail/blocs/location_bloc.dart';
import 'package:alabama_beer_trail/blocs/trail_places_bloc.dart';
import 'package:alabama_beer_trail/util/geo_methods.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/data/trail_place_category.dart';
import 'package:alabama_beer_trail/widgets/trailplace_list.dart';

import '../util/filter_options.dart';
import 'tabscreen_child.dart';
import 'package:flutter/material.dart';
import '../data/trail_place.dart';
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
  var _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  var _places = List<TrailPlace>();
  FilterOptions _filter;

  Widget _refreshChildWidget = Center(child: CircularProgressIndicator());

  var _trailPlacesBloc = TrailPlacesBloc();
  var _locationBloc = LocationBloc();

  _TabScreenTrail() {
    // Set up initial filter options
    var initialShow = Map<TrailPlaceCategory, bool>();
    TrailAppSettings.filterStrings.forEach((f) => initialShow[f] = true);
    this._filter = FilterOptions(SortOrder.DISTANCE, initialShow);
  }

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
    if(_locationBloc.hasPermission && _locationBloc.lastLocation == null) {
      // Wait for location to update.
      return; 
    }
    sortPlaces();
    var places = filterPlaces();

    // We have to delay the setState to "trick" Flutter
    // into actually disposing and regenerating the listview
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _refreshChildWidget = TrailListView(places: places);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      key: this._refreshIndicatorKey,
      onRefresh: () {
        setState(() {
          this._refreshChildWidget = Center(child: CircularProgressIndicator());
        });        
        return _locationBloc.refreshLocation();
      },
      child: _refreshChildWidget,
    );
  }

  void sortPlaces() {
    if (this._filter.sort == SortOrder.DISTANCE &&
        _locationBloc.hasPermission &&
        _locationBloc.lastLocation != null) {
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
        return ModalTrailFilter(initialOptions: this._filter);
      },
    ).then((value) {
      this._filter = value;
      setState(() {
        this._refreshChildWidget = Center(child: CircularProgressIndicator());
      });      
      this._refreshPlaces();
    });
  }

  List<TrailPlace> filterPlaces() {
    var placesToShow = Set<TrailPlace>();
    this._filter.show.forEach((cat, show) {
      if (show) {
        this._places.forEach((p) {
          if (p.categories.contains(cat.name)) {
            placesToShow.add(p);
          }
        });
      }
    });

    return placesToShow.toList();
  }

  @override
  bool get wantKeepAlive => true;
}
