import 'package:alabama_beer_trail/data/trail_event.dart';
import 'package:alabama_beer_trail/util/app_launcher.dart';
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
                elevation: 1.0,
              ),
              // Event Image
              Visibility(
                visible: this.event.eventImageUrl != null &&
                    this.event.eventImageUrl != '',
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return CachedNetworkImage(
                      height: constraints.maxWidth * (9/16),
                      width: double.infinity,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      imageUrl: this.event.eventImageUrl ?? '',
                    );
                  },
                ),
              ),
              // Event Details
              Visibility(
                visible: this.event.eventDetails.isNotEmpty,
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(bottom: 6.0),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                      "Event Details",
                      style: TextStyle(
                        fontSize: 22.0,
                        color: TrailAppSettings.second,
                      ),
                    ),
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        margin: EdgeInsets.only(bottom: 6.0, left: 10.0),
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: ExpandableText(
                          isExpanded: false,
                          text: this.event.eventDetails,
                          fontSize: 16.0,
                          previewCharacterCount: 200,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: !this.event.eventDetails.isNotEmpty,
                child: SizedBox(
                  height: 6.0,
                ),
              ),
              // Date and Time
              Container(
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 6.0),
                child: ExpansionTile(
                  initiallyExpanded: false,
                  title: Text(
                    "Date and Time",
                    style: TextStyle(
                      fontSize: 22.0,
                      color: TrailAppSettings.second,
                    ),
                  ),
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                            left: 10.0,
                            right: 16.0,
                            bottom: 16.0,
                          ),
                          child: Container(
                            color: Colors.white,
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                            DateFormat("h:mm a")
                                                .format(this.event.eventStart),
                                            style: TextStyle(
                                              color: Color(0xFF666666),
                                              fontSize: 20.0,
                                            ),
                                          ),
                                          event.noEndTime
                                              ? Text(" ")
                                              : Text(
                                                  " ${String.fromCharCode(0x2014)} " +
                                                      DateFormat("h:mm a")
                                                          .format(this
                                                              .event
                                                              .eventEnd),
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
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Location
              Visibility(
                visible: this.event.eventLocationName != null &&
                    this.event.eventLocationName.isNotEmpty,
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(bottom: 6.0),
                  child: ExpansionTile(
                    initiallyExpanded: false,
                    title: Text(
                      "Location",
                      style: TextStyle(
                        fontSize: 22.0,
                        color: TrailAppSettings.second,
                      ),
                    ),
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                          bottom: 16.0,
                        ),
                        child: Container(
                          color: Colors.white,
                          alignment: Alignment.topLeft,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                this.event.eventLocationName ?? "",
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
                                this.event.eventLocationAddress ?? "",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20.0,
                                ),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              RaisedButton(
                                onPressed: () {
                                  AppLauncher().openDirections(
                                      this.event.eventLocationName +
                                          ", " +
                                          this.event.eventLocationAddress);
                                },
                                color: TrailAppSettings.third,
                                elevation: 12.0,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                textColor: Colors.white,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.drive_eta,
                                    ),
                                    SizedBox(
                                      width: 16.0,
                                    ),
                                    Text(
                                      "Get Directions",
                                      style: TextStyle(),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
