import 'package:alabama_beer_trail/blocs/trail_places_bloc.dart';
import 'package:alabama_beer_trail/widgets/trailplace_list.dart';
import 'package:alabama_beer_trail/blocs/tabselection_bloc.dart';

import 'package:flutter/material.dart';
import '../data/trail_place.dart';

/// The trail list screen
///
/// This is a sub-screen for the Trail Tab
class TabScreenTrailList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabScreenTrailList();
}

/// The state of the trail list screen
///
class _TabScreenTrailList extends State<TabScreenTrailList>
    with AutomaticKeepAliveClientMixin<TabScreenTrailList> {

  _TabScreenTrailList() {
    _tabSelectionBloc.tabSelectionStream.listen((newTab) {
        if (newTab == 0 && _tabSelectionBloc.lastTapSame) {
          _trailListViewKey.currentState.scrollToTop();
        }
    });
  }

  /// The global key for the list view state
  var _trailListViewKey = GlobalKey<TrailListViewState>();

  /// The BLoC for the app tab selection
  TabSelectionBloc _tabSelectionBloc = TabSelectionBloc();

  /// The BloC for the trail places
  var _trailPlacesBloc = TrailPlacesBloc();

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
