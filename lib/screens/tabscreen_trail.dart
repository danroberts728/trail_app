import 'package:alabama_beer_trail/blocs/trail_places_bloc.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/widgets/trailplace_list.dart';

import 'package:flutter/material.dart';
import '../data/trail_place.dart';

class TabScreenTrail extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _TabScreenTrail();
}

class _TabScreenTrail extends State<TabScreenTrail>
    with AutomaticKeepAliveClientMixin<TabScreenTrail> {

  var _trailListViewKey = GlobalKey<TrailListViewState>();
  var _trailPlacesBloc = TrailPlacesBloc();

  void _searchKeyTapped() {
    _trailListViewKey.currentState.showSearchBar();
  }

  void filterPressed() {
    _trailListViewKey.currentState.showFilterModal();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(TrailAppSettings.navBarTrailTabTitle),
        actions: <IconButton>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              this._searchKeyTapped();
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: filterPressed,
          ),
        ],
      ),
      body: StreamBuilder(
          stream: _trailPlacesBloc.trailPlaceStream,
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            else {
              List<TrailPlace> places = snapshot.data;
              return TrailListView(
                key: _trailListViewKey,
                places: places
              );
            }
          },
        ),
    );
  }
  

  @override
  bool get wantKeepAlive => true;
}
