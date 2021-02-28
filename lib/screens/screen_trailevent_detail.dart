// Copyright (c) 2021, Fermented Software.
import 'package:beer_trail_database/domain/trail_event.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:beer_trail_app/util/app_launcher.dart';
import 'package:beer_trail_app/util/trail_app_settings.dart';
import 'package:beer_trail_app/widgets/trailevent_card.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';

class TrailEventDetailScreen extends StatelessWidget {
  final TrailEvent event;

  const TrailEventDetailScreen({Key key, this.event}) : super(key: key);

  String _getTimeString(TrailEvent event) {
    if (event.allDayEvent) {
      return " (All Day: " + DateFormat("EEEEE").format(event.start) + ") ";
    } else if (event.hideEndTime) {
      return DateFormat("h:mm a").format(event.start);
    } else {
      return DateFormat("h:mm a").format(event.start) +
          " - " +
          DateFormat("h:mm a").format(event.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          HtmlUnescape().convert(event.name),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              // Event Card
              TrailEventCard(
                isClickable: false,
                event: this.event,
                startMargin: 0.0,
                endMargin: 0.0,
                titleOverflow: TextOverflow.visible,
                titleMaxLines: 5,
                elevation: 0.0,
              ),
              // Event Details
              Visibility(
                visible: event.details != null && event.details.isNotEmpty,
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(bottom: 6.0),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                      "Details",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: TrailAppSettings.mainHeadingColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 6.0, left: 10.0),
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: <Widget>[
                            HtmlWidget(
                              this.event.details,
                              onTapUrl: (url) => AppLauncher().openWebsite(url),
                            ),
                            Visibility(
                              visible: event.learnMoreLink != null &&
                                  event.learnMoreLink != "",
                              child: SizedBox(
                                width: double.infinity,
                                child: RaisedButton(
                                  color: TrailAppSettings.actionLinksColor,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    AppLauncher()
                                        .openWebsite(event.learnMoreLink);
                                  },
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text("Learn More"),
                                        SizedBox(
                                          width: 8.0,
                                        ),
                                        Icon(Icons.open_in_new)
                                      ]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: event.details != null && event.details.isNotEmpty,
                child: SizedBox(
                  height: 6.0,
                ),
              ),
              // Date and Time
              Container(
                margin: EdgeInsets.only(bottom: 6.0),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  title: Text(
                    "When",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: TrailAppSettings.mainHeadingColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.only(bottom: 6.0, left: 10.0, right: 10.0),
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.calendar_today,
                            size: 26.0,
                            color: Colors.black54,
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  DateFormat("EEEEE, MMMM dd, yyyy")
                                      .format(this.event.start),
                                  style: TextStyle(
                                    color: Color(0xFF666666),
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.fade,
                                ),
                                Text(
                                  _getTimeString(event),
                                  style: TextStyle(
                                    color: Color(0xFF666666),
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Location
              Visibility(
                visible:
                    event.locationName != null && event.locationName.isNotEmpty,
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(bottom: 6.0),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                      "Where",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: TrailAppSettings.mainHeadingColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            bottom: 6.0, left: 10.0, right: 10.0),
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              size: 26.0,
                              color: Colors.black54,
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    event.locationName,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                      color: Color(0xFF666666),
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    event.locationAddress,
                                    style: TextStyle(
                                      color: Color(0xFF666666),
                                      fontSize: 14.0,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: FlatButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  AppLauncher().openDirections(
                                      event.locationName +
                                          ", " +
                                          event.locationAddress);
                                },
                                child: Column(
                                  children: <Widget>[
                                    Icon(
                                      Icons.directions,
                                      color: TrailAppSettings.actionLinksColor,
                                      size: 32.0,
                                    ),
                                    Text(
                                      "Directions",
                                      style: TextStyle(
                                        color:
                                            TrailAppSettings.actionLinksColor,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
