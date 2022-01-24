// Copyright (c) 2021, Fermented Software
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:trail_database/trail_database.dart';
import 'package:trailtab_events/trailtab_events.dart';
import 'package:trailtab_places/trailtab_places.dart';

class NotificationHandler {
  TrailDatabase _db;

  NotificationHandler(TrailDatabase db) {
    _db = db;
  }

  List<TrailPlace> places = <TrailPlace>[];
  List<TrailEvent> events = <TrailEvent>[];

  Future handleNotificationLaunch(
      BuildContext context, RemoteMessage message) {
    return _navigateNotificationRoute(context, message.data);
  }

  Future handleNotificationMessage(
      BuildContext context, RemoteMessage message) {
    return _showNotificationSnackBar(context, message.data);
  }

  Future handleNotificationResume(
      BuildContext context, Map<String, dynamic> message) {
    return _navigateNotificationRoute(context, message);
  }

  Future<void> _showNotificationSnackBar(
      BuildContext context, Map<dynamic, dynamic> message) async {
    var data = message['data'] ?? message;
    String gotoPlace = data['gotoPlace'];
    String gotoEvent = data['gotoEvent'];
    String gotoLink = data['gotoLink'];
    String title = message['notification']['title'];

    if (gotoPlace != null) {
      var place =
          _db.places.firstWhere((p) => p.id == gotoPlace, orElse: () => null);
      if (place != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(title),
          duration: Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Go',
            onPressed: () => _openPlace(context, place),
          ),
        ));
      }
    } else if (gotoEvent != null) {
      var event =
          _db.events.firstWhere((e) => e.id == gotoEvent, orElse: () => null);
      if (event != null) {}
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(title),
        duration: Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Go',
          textColor: Theme.of(context).textTheme.button.color,
          onPressed: () => _openEvent(context, event),
        ),
      ));
    } else if (gotoLink != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(title),
        duration: Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Go',
          textColor: Theme.of(context).textTheme.button.color,
          onPressed: () {
            launch(gotoLink);
          },
        ),
      ));
    }
  }

  Future<void> _navigateNotificationRoute(
      BuildContext context, Map<dynamic, dynamic> message) async {
    var data = message['data'] ?? message;
    String gotoPlace = data['gotoPlace'];
    String gotoEvent = data['gotoEvent'];
    String gotoLink = data['gotoLink'];

    if (gotoPlace != null) {
      var place =
          _db.places.firstWhere((p) => p.id == gotoPlace, orElse: () => null);
      if (place != null) {
        _openPlace(context, place);
      } else {
        _db.placesStream.listen((newPlaces) {
          place = newPlaces.firstWhere((p) => p.id == gotoPlace);
          _openPlace(context, place);
        });
      }
    } else if (gotoEvent != null) {
      var event =
          _db.events.firstWhere((e) => e.id == gotoEvent, orElse: () => null);
      if (event != null) {
        _openEvent(context, event);
      } else {
        _db.eventsStream.listen((newEvents) {
          event = newEvents.firstWhere((e) => e.id == gotoEvent);
          _openEvent(context, event);
        });
      }
    } else if (gotoLink != null) {
      launch(gotoLink);
    }
  }

  void _openPlace(BuildContext context, TrailPlace place) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.push(
        context,
        MaterialPageRoute(
            settings: RouteSettings(
              name: '/place/${place.id}',
            ),
            builder: (context) => TrailPlaceDetailScreen(place: place)));
  }

  void _openEvent(BuildContext context, TrailEvent event) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.push(
        context,
        MaterialPageRoute(
            settings: RouteSettings(
              name: '/event/${event.id}',
            ),
            builder: (context) => TrailEventDetailScreen(event: event)));
  }
}
