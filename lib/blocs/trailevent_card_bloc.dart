import 'dart:async';
import 'package:html/dom.dart' as htmlParser;

import 'package:alabama_beer_trail/blocs/bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/trail_event.dart';
import 'package:add_to_calendar/add_to_calendar.dart';

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

  void exportToCalendar() {
    AddToCalendar.addToCalendar(
          title: event.name,
          startTime: event.start.toLocal(),
          endTime: event.hideEndTime
            ? event.start.toLocal().add(Duration(hours: 1))
            : event.end.toLocal(),
          location:
              "${event.locationName}, ${event.locationAddress}, ${event.locationCity}, ${event.locationState}",
          description: htmlParser.DocumentFragment.html(event.details).text,
          isAllDay: event.allDayEvent,
    );
  }

  void _onEventsUpdate(List<TrailEvent> newEvent) {
    event = newEvent.firstWhere((e) => e.id == _eventId);
    _controller.add(null);
    _controller.sink.add(event);
  }

  @override
  void dispose() {
    _eventsSubscription.cancel();
    _controller.close();
  }
}
