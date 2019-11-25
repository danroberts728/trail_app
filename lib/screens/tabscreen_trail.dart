import 'package:alabama_beer_trail/blocs/trail_places_bloc.dart';
import 'package:alabama_beer_trail/widgets/trailplace_list.dart';

import 'package:flutter/material.dart';
import '../data/trail_place.dart';

/// The trail tab screen
///
/// This is the major screen for the app
class TabScreenTrail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabScreenTrail();
}

/// The state of the trail tab screen
///
class _TabScreenTrail extends State<TabScreenTrail>
    with AutomaticKeepAliveClientMixin<TabScreenTrail> {
  /// The global ke yfor the list view state
  var _trailListViewKey = GlobalKey<TrailListViewState>();

  /// The BloC for the trail places
  var _trailPlacesBloc = TrailPlacesBloc();

  void filterPressed() {
    _trailListViewKey.currentState.showFilterModal();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
      stream: _trailPlacesBloc.trailPlaceStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          List<TrailPlace> places = snapshot.data;
          return TrailListView(key: _trailListViewKey, places: places);
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
