import 'dart:async';

import 'package:alabama_beer_trail/blocs/tabscreen_trail_events_bloc.dart';
import 'package:alabama_beer_trail/widgets/top_event_filter.dart';
import 'package:alabama_beer_trail/data/trail_event.dart';
import 'package:alabama_beer_trail/util/tabselection_service.dart';
import 'package:alabama_beer_trail/widgets/trailevent_card.dart';
import 'package:flutter/material.dart';

class TabScreenTrailEvents extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabScreenTrailEvents();
}

class _TabScreenTrailEvents extends State<TabScreenTrailEvents> {
  TabScreenTrailEventsBloc _tabScreenTrailEventsBloc =
      TabScreenTrailEventsBloc();

  /// The BLoC for the app tab selection
  final _tabSelectionService = TabSelectionService();

  ScrollController _controller = ScrollController();

  _TabScreenTrailEvents() {
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
              } else if (!snapshot.hasData || snapshot.data.length == 0) {
                return Center(child: Text("No events found."));
              } else {
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return TopEventFilter();
                    } else {
                      TrailEvent event = snapshot.data[index-1];
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

  void _scrollToTop(newTab) {
    if (newTab == 1 && _tabSelectionService.lastTapSame) {
      _controller.animateTo(0.0,
          duration: Duration(milliseconds: _controller.position.pixels ~/ 2),
          curve: Curves.easeOut);
    }
  }

  Future<void> _refreshPulled() {
    return Future.delayed(Duration(seconds: 1), () {
      _tabScreenTrailEventsBloc.refreshLocation();
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Events list updated.")));
    });
  }
}
