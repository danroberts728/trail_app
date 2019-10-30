import 'package:alabama_beer_trail/data/trailevent.dart';
import 'package:alabama_beer_trail/screens/screen_trailevent_detail.dart';
import 'package:alabama_beer_trail/util/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class TrailEventCard extends StatefulWidget {
  final TrailEvent event;
  final double startMargin;
  final TextOverflow titleOverflow;
  final double colorBarWidth;

  TrailEventCard(
      {@required this.event,
      this.startMargin = 8.0,
      this.titleOverflow = TextOverflow.ellipsis,
      this.colorBarWidth = 3.0});

  @override
  State<StatefulWidget> createState() => _TrailEventCard();
}

class _TrailEventCard extends State<TrailEventCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                settings: RouteSettings(
                  name: 'Trail Event - ' + widget.event.eventName,
                ),
                builder: (context) =>
                    TrailEventDetailScreen(event: widget.event)));
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(
          left: widget.startMargin,
          right: 4.0,
        ),
        child: Card(
          elevation: 4.0,
          margin: EdgeInsets.all(0.0),
          child: Container(
            decoration: BoxDecoration(
              border: BorderDirectional(
                start: BorderSide(
                  color: widget.event.eventColor,
                  width: widget.colorBarWidth,
                ),
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 35.0,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          DateFormat("EEE")
                              .format(widget.event.eventStart)
                              .toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0,
                              color: Constants.colors.third,
                              fontFamilyFallback: ["Arial Narrow"],
                              fontFamily: "Roboto"),
                        ),
                        Text(
                          DateFormat("dd")
                              .format(widget.event.eventStart)
                              .toUpperCase(),
                          style: TextStyle(
                              fontSize: 22.0,
                              height: 1.0,
                              fontWeight: FontWeight.bold,
                              color: Constants.colors.third,
                              fontFamilyFallback: ["Arial Narrow"],
                              fontFamily: "Roboto"),
                        ),
                        Text(
                          DateFormat("MMM")
                              .format(widget.event.eventStart)
                              .toUpperCase(),
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                              color: Constants.colors.third,
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
                          widget.event.eventName,
                          overflow: widget.titleOverflow,
                          style: TextStyle(
                              color: Constants.colors.first,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                        ),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.access_time,
                            color: Color(0xFF989999),
                            size: 14.0,
                          ),
                          widget.event.isEventAllDay
                              ? Text(
                                  " (All Day: " +
                                      DateFormat("EEEEE")
                                          .format(widget.event.eventStart) +
                                      ") ",
                                  style: TextStyle(
                                    color: Color(0xFF666666),
                                    fontSize: 14.0,
                                  ),
                                )
                              : Text(
                                  DateFormat(" h:mm a")
                                      .format(widget.event.eventStart),
                                  style: TextStyle(
                                    color: Color(0xFF666666),
                                    fontSize: 14.0,
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            color: Color(0xFF666666),
                            size: 14.0,
                          ),
                          Text(
                            " " + widget.event.eventLocationName,
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
