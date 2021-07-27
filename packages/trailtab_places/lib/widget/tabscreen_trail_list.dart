// Copyright (c) 2020, Fermented Software.
import 'package:trailtab_places/bloc/tabscreen_trail_list_bloc.dart';
import 'package:trail_database/trail_database.dart';
import 'package:trail_database/domain/trail_place.dart';
import 'package:trail_location_service/trail_location_service.dart';
import 'package:trailtab_places/util/place_filter.dart';
import 'package:trailtab_places/widget/top_list_sort_and_filter.dart';
import 'package:trailtab_places/widget/trailplace_card.dart';

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
  }

  /// The filter for the trail place list on this tab screen
  final PlaceFilter _placeFilter = PlaceFilter();

  /// The ListView Controller
  final _listViewController = ScrollController();

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

  @override
  bool get wantKeepAlive => true;
}
