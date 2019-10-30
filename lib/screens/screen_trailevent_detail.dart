import 'package:alabama_beer_trail/data/trail_event.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/widgets/trailevent_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TrailEventDetailScreen extends StatelessWidget {
  final TrailEvent event;

  const TrailEventDetailScreen({Key key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.eventName),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            // Event Card
            TrailEventCard(
              event: this.event,
              startMargin: 0.0,
              titleOverflow: TextOverflow.visible,
              colorBarWidth: 6.0,
            ),
            // Event Image
            Visibility(
              visible: this.event.eventImageUrl != null &&
                  this.event.eventImageUrl != '',
              child: CachedNetworkImage(
                height: 200.0,
                width: double.infinity,
                fit: BoxFit.cover,
                imageUrl: this.event.eventImageUrl ?? '',
              ),
            ),
            // Title: Event Details
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Event Details".toUpperCase(),
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: TrailAppSettings.first,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            // Event Description
            Container(
              
            ),
          ],
        ),
      ),
    );
  }
}
