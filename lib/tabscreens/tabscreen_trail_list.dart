// Copyright (c) 2020, Fermented Software.
import 'package:beer_trail_app/blocs/tabscreen_trail_list_bloc.dart';
import 'package:beer_trail_database/trail_database.dart';
import 'package:beer_trail_database/domain/trail_place.dart';
import 'package:trail_location_service/trail_location_service.dart';
import 'package:beer_trail_app/util/place_filter.dart';
import 'package:beer_trail_app/widgets/top_list_sort_and_filter.dart';
import 'package:beer_trail_app/widgets/trailplace_card.dart';
import 'package:beer_trail_app/util/tabselection_service.dart';

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
    _bloc = TabScreenTrailListBloc(_placeFilter, TrailDatabase(), TrailLocationService());
    _tabSelectionService.tabSelectionStream.listen(_scrollToTop);
  }

  /// The filter for the trail place list on this tab screen
  final PlaceFilter _placeFilter = PlaceFilter();

  /// The ListView Controller
  final _listViewController = ScrollController();

  /// The BLoC for the app tab selection
  final _tabSelectionService = TabSelectionService();

  /// The BloC for the trail places
  TabScreenTrailListBloc _bloc;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
      stream: _bloc.filteredTrailPlacesStream,
      initialData: _bloc.filteredTrailPlaces,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Icon(Icons.error));
        } else {
          List<TrailPlace> places = snapshot.data;
          return RefreshIndicator(
            onRefresh: _refreshPulled,
            child: Container(
              height: double.infinity,
              color: Colors.black12,
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.all(0),
              child: ListView.builder(
                controller: _listViewController,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: places.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return TopListSortAndFilter(_placeFilter);
                  } else {
                    return TrailPlaceCard(
                      key: ValueKey(places[index - 1].id),
                      place: places[index - 1],
                    );
                  }
                },
              ),
            ),
          );
        }
      },
    );
  }

  Future<void> _refreshPulled() {
    return _bloc.refreshPulled().then((_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Places updated.")));
    });
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
