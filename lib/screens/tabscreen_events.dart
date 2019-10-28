import 'package:alabama_beer_trail/blocs/events_bloc.dart';
import 'package:alabama_beer_trail/data/trailevent.dart';
import 'package:alabama_beer_trail/screens/tabscreen_child.dart';
import 'package:alabama_beer_trail/widgets/trailevent_card.dart';
import 'package:flutter/material.dart';

class TabScreenEvents extends StatefulWidget implements TabScreenChild {
  final _TabScreenEvents _state = _TabScreenEvents();
  @override
  State<StatefulWidget> createState() => _state;

  @override
  List<IconButton> getAppBarActions() {
    return _state.getAppBarActions();
  }
}

class _TabScreenEvents extends State<TabScreenEvents> {
  EventsBloc _eventsBloc = EventsBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _eventsBloc.trailPlaceStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<TrailEvent> events = snapshot.data;
            return Container(
              width: double.infinity,
              height: double.infinity,
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return TrailEventCard(
                    event: events[index],
                  );
                },
              ),
            );
          }
        });
  }

  List<IconButton> getAppBarActions() {
    return List<IconButton>();
  }
}
