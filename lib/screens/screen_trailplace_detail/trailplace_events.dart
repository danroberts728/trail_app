import 'package:alabama_beer_trail/blocs/trailplace_events_bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/trail_event.dart';
import 'package:alabama_beer_trail/widgets/trailevent_card.dart';
import 'package:flutter/material.dart';

/// UI element for a list of events at a trail place
class TrailPlaceEvents extends StatefulWidget {
  /// The location taxonomy for the venue.
  /// 
  /// This ties in the two systems - trail events use a location taxonomy to
  /// identify the venue. Trail places have a different ID
  final int locationTaxonomy;

  const TrailPlaceEvents({Key key, @required this.locationTaxonomy}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _TrailPlaceEvents();
}

class _TrailPlaceEvents extends State<TrailPlaceEvents> {
  TrailPlaceEventsBloc _bloc;

  @override
  void initState() {
    _bloc = TrailPlaceEventsBloc(widget.locationTaxonomy, TrailDatabase());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.trailEventsStream,
      initialData: _bloc.trailPlaceEvents,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Icon(Icons.error));
        } else {
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              TrailEvent event = snapshot.data[index];
              return TrailEventCard(
                key: ValueKey(event.id),
                startMargin: 4.0,
                endMargin: 4.0,
                bottomMargin: 0.0,
                showImage: true,
                elevation: 8.0,
                event: event,
              );
            },
          );
        }
      },
    );
  }
}
