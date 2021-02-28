// Copyright (c) 2020, Fermented Software.
import 'dart:async';

import 'package:beer_trail_app/blocs/tabscreen_trail_events_bloc.dart';
import 'package:beer_trail_database/trail_database.dart';
import 'package:beer_trail_app/util/event_filter.dart';
import 'package:beer_trail_app/util/location_service.dart';
import 'package:beer_trail_app/widgets/dropdown_event_filter.dart';
import 'package:beer_trail_database/domain/trail_event.dart';
import 'package:beer_trail_app/util/tabselection_service.dart';
import 'package:beer_trail_app/widgets/trailevent_card.dart';
import 'package:flutter/material.dart';

/// The Trail Events tab screen
class TabScreenTrailEvents extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabScreenTrailEvents();
}

/// The state for the Trail Events tab
class _TabScreenTrailEvents extends State<TabScreenTrailEvents> {
  /// The BLoC for the app tab selection
  TabScreenTrailEventsBloc _tabScreenTrailEventsBloc;

  /// A service to communicate tab changes
  final _tabSelectionService = TabSelectionService();

  /// The filter used for events
  EventFilter _filter;

  /// Controller for the vertical scroll widget
  ScrollController _controller = ScrollController();

  /// Default constructor
  _TabScreenTrailEvents() {
    _filter = EventFilter(locationService: LocationService());
    _tabScreenTrailEventsBloc = TabScreenTrailEventsBloc(TrailDatabase(), _filter, LocationService());
    _tabSelectionService.tabSelectionStream.listen(_scrollToTop);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshPulled,
      child: Container(
        color: Colors.black12,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          controller: _controller,
          child: StreamBuilder(
            stream: _tabScreenTrailEventsBloc.trailEventsStream,
            initialData: _tabScreenTrailEventsBloc.filteredTrailEvents,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Icon(Icons.error));
              } else {
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return DropDownEventFilter(filter: _filter,);
                    } else {
                      TrailEvent event = snapshot.data[index - 1];
                      return TrailEventCard(
                        key: ValueKey(event.id),
                        startMargin: 4.0,
                        endMargin: 4.0,
                        bottomMargin: 0.0,
                        showImage: true,
                        elevation: 8.0,
                        event: event,
                      );
                    }
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  /// Scrolls the tab to the top of the vertical scroll
  void _scrollToTop(newTab) {
    if (newTab == 1 && _tabSelectionService.lastTapSame) {
      _controller.animateTo(0.0,
          duration: Duration(milliseconds: _controller.position.pixels ~/ 2),
          curve: Curves.easeOut);
    }
  }

  /// Handle refresh pulldown
  Future<void> _refreshPulled() {
    return _tabScreenTrailEventsBloc.refreshLocation().then((_) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Events updated.")));
    });
  }
}
