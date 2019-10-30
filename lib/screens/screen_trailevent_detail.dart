import 'package:alabama_beer_trail/data/trail_event.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/widgets/expandable_text.dart';
import 'package:alabama_beer_trail/widgets/trailevent_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrailEventDetailScreen extends StatelessWidget {
  final TrailEvent event;

  const TrailEventDetailScreen({Key key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.eventName),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              // Event Card
              TrailEventCard(
                event: this.event,
                startMargin: 0.0,
                endMargin: 0.0,
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
              Visibility(
                visible: this.event.eventDetails.isNotEmpty,
                child: Container(
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
              ),
              // Event Description
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: ExpandableText(
                  isExpanded: false,
                  text: this.event.eventDetails,
                  fontSize: 16.0,
                  previewCharacterCount: 200,
                ),
              ),
              // Title: Event Time
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Date and Time".toUpperCase(),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: TrailAppSettings.first,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              // Event Time
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      DateFormat("EEEEE, MMMM dd, yyyy")
                          .format(this.event.eventStart),
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    this.event.isEventAllDay
                        ? Text(
                            " (All Day: " +
                                DateFormat("EEEEE")
                                    .format(this.event.eventStart) +
                                ") ",
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 20.0,
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        : Row(
                            children: <Widget>[
                              Text(
                                DateFormat(" h:mm a")
                                    .format(this.event.eventStart),
                                style: TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: 20.0,
                                ),
                              ),
                              event.noEndTime
                                  ? Text(
                                      " No End Time",
                                      style: TextStyle(
                                        color: Color(0xFF666666),
                                        fontSize: 20.0,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    )
                                  : Text(
                                      " ${String.fromCharCode(0x2014)} " +
                                          DateFormat(" h:mm a")
                                              .format(this.event.eventEnd),
                                      style: TextStyle(
                                        color: Color(0xFF666666),
                                        fontSize: 20.0,
                                      ),
                                    ),
                            ],
                          ),
                  ],
                ),
              ),
              // Title: Location
              Container(
                margin: EdgeInsets.only(
                  top: 16.0,
                ),
                width: double.infinity,
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Location".toUpperCase(),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: TrailAppSettings.first,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              // Location
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      this.event.eventLocationName,
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      this.event.eventLocationAddress,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
