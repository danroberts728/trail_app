import 'dart:async';
import 'package:html/dom.dart' as htmlParser;

import 'package:alabama_beer_trail/blocs/bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/trail_event.dart';
import 'package:add_2_calendar/add_2_calendar.dart' as a2c;

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
    a2c.Add2Calendar.addEvent2Cal(
      a2c.Event(
          title: event.name,
          description: htmlParser.DocumentFragment.html(event.details).text,
          location:
              "${event.locationName}, ${event.locationAddress}, ${event.locationCity}, ${event.locationState}",
          timeZone: event.start.timeZoneName,
          startDate: event.start.toLocal(),          
          endDate: event.hideEndTime
              ? event.start.toLocal().add(Duration(hours: 1))
              : event.end.toLocal()),
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
