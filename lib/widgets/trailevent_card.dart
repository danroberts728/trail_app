import 'package:alabama_beer_trail/data/trailevent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class TrailEventCard extends StatefulWidget {
  final TrailEvent event;

  TrailEventCard({@required this.event});

  @override
  State<StatefulWidget> createState() => _TrailEventCard(this.event);
}

class _TrailEventCard extends State<TrailEventCard> {
  final TrailEvent event;

  _TrailEventCard(this.event);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 16.0,
        ),
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
        decoration: BoxDecoration(
          border: BorderDirectional(
            start: BorderSide(
              color: event.eventColor,
              width: 3.0,
            ),
            top: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
            bottom: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
        ),
        width: double.infinity,
        child: Row(          
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,      
          children: <Widget>[
            SizedBox(
              width: 30.0,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      DateFormat("EEE").format(event.eventStart).toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.0,
                          color: Color(0xFFABABAB),
                          fontFamilyFallback: ["Arial Narrow"],
                          fontFamily: "Roboto"),
                    ),
                    Text(
                      DateFormat("dd").format(event.eventStart).toUpperCase(),
                      style: TextStyle(
                          fontSize: 20.0,
                          height: 1.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFABABAB),
                          fontFamilyFallback: ["Arial Narrow"],
                          fontFamily: "Roboto"),
                    ),
                    Text(
                      DateFormat("MMM").format(event.eventStart).toUpperCase(),
                      style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFABABAB),
                          fontFamilyFallback: ["Arial Narrow"],
                          fontFamily: "Roboto"),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 16.0,
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      event.eventName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.access_time,
                        color: Color(0xFF989999),
                        size: 14.0,
                      ),
                      event.isEventAllDay
                          ? Text(
                              " (All Day: " +
                                  DateFormat("EEEEE").format(event.eventStart) +
                                  ") ",
                              style: TextStyle(
                                color: Color(0xFF989999),
                                fontSize: 14.0,
                              ),
                            )
                          : Text(
                              DateFormat(" h:m a").format(event.eventStart),
                              style: TextStyle(
                                color: Color(0xFF989999),
                                fontSize: 14.0,
                              ),
                            ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: Color(0xFF989999),
                        size: 14.0,
                      ),
                      Text(
                        " " + event.eventLocationName,
                        style: TextStyle(
                          color: Color(0xFF989999),
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
