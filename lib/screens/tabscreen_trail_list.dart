import 'package:alabama_beer_trail/blocs/tabscreen_trail_list_bloc.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/widgets/trailplace_card.dart';
import 'package:alabama_beer_trail/util/tabselection_service.dart';

import 'package:flutter/material.dart';

/// The trail list screen
/// This is a sub-screen for the Trail Tab
class TabScreenTrailList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabScreenTrailList();
}

/// The state of the trail list screen
class _TabScreenTrailList extends State<TabScreenTrailList>
    with AutomaticKeepAliveClientMixin<TabScreenTrailList> {
  _TabScreenTrailList() {
    _tabSelectionService.tabSelectionStream.listen(_scrollToTop);
  }

  /// The ListView Controller
  final _listViewController = ScrollController();

  /// The BLoC for the app tab selection
  final _tabSelectionService = TabSelectionService();

  /// The BloC for the trail places
  var _bloc = TabScreenTrailListBloc();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
      stream: _bloc.filteredTraiilPlacesStream,
      initialData: _bloc.filteredTrailPlaces,
      builder: (context, snapshot) {
        List<TrailPlace> places = snapshot.data;
        return RefreshIndicator(
          onRefresh: _bloc.refreshPulled,
          child: Container(
            color: Colors.black12,
            child: Container(
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.all(0),
              child: ListView.builder(
                controller: _listViewController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: places.length,
                itemBuilder: (context, index) {
                  return TrailPlaceCard(
                    key: ValueKey(places[index].id),
                    place: places[index],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _scrollToTop(newTab) {
    if (newTab == 0 && _tabSelectionService.lastTapSame) {
      _listViewController.animateTo(0.0,
          duration:
              Duration(milliseconds: _listViewController.position.pixels ~/ 2),
          curve: Curves.easeOut);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
