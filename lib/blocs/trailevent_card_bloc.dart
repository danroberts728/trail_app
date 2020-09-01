import 'dart:async';

import 'package:alabama_beer_trail/blocs/bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/trail_event.dart';

class TrailEventCardBloc extends Bloc {
  final _db = TrailDatabase();
  StreamSubscription _eventsSubscription;

  String _eventId;
  TrailEvent event;

  final _controller = StreamController<TrailEvent>();
  Stream<TrailEvent> get stream => _controller.stream;

  TrailEventCardBloc(String eventId) {
    _eventId = eventId;
    event = _db.events.firstWhere((e) => e.id == _eventId);
    _eventsSubscription = _db.eventsStream.listen(_onEventsUpdate);
  }

  void _onEventsUpdate(List<TrailEvent> newEvent) {
    event = newEvent.firstWhere((e) => e.id == _eventId);
    _controller.sink.add(event);
  }

  @override
  void dispose() {
    _eventsSubscription.cancel();
    _controller.close();
  }

}