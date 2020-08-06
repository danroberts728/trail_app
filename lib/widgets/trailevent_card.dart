import 'package:alabama_beer_trail/data/trail_event.dart';
import 'package:alabama_beer_trail/screens/screen_trailevent_detail.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';

class TrailEventCard extends StatefulWidget {
  final TrailEvent event;
  final double startMargin;
  final double endMargin;
  final TextOverflow titleOverflow;
  final double colorBarWidth;
  final double elevation;

  TrailEventCard(
      {@required this.event,
      this.startMargin = 0.0,
      this.titleOverflow = TextOverflow.ellipsis,
      this.colorBarWidth = 3.0,
      this.endMargin = 0.0,
      this.elevation = 4.0});

  @override
  State<StatefulWidget> createState() => _TrailEventCard();
}

class _TrailEventCard extends State<TrailEventCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Feedback.forTap(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                settings:
                    RouteSettings(name: 'Trail Event - ' + widget.event.name),
                builder: (context) =>
                    TrailEventDetailScreen(event: widget.event)));
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(
          left: widget.startMargin,
          right: widget.endMargin,
        ),
        child: Card(
          elevation: widget.elevation,
          margin: EdgeInsets.all(0.0),
          child: Container(
            decoration: BoxDecoration(
              color:
                  widget.event.featured ? Color(0xfffff6e2) : Color(0x00025c6e),
              border: BorderDirectional(
                start: BorderSide(
                  color: widget.event.color,
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
                // Date Box
                SizedBox(
                  width: 35.0,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          DateFormat("EEE")
                              .format(widget.event.start)
                              .toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0,
                              color: TrailAppSettings.third,
                              fontFamilyFallback: ["Arial Narrow"],
                              fontFamily: "Roboto"),
                        ),
                        Text(
                          DateFormat("dd")
                              .format(widget.event.start)
                              .toUpperCase(),
                          style: TextStyle(
                              fontSize: 22.0,
                              height: 1.0,
                              fontWeight: FontWeight.bold,
                              color: TrailAppSettings.third,
                              fontFamilyFallback: ["Arial Narrow"],
                              fontFamily: "Roboto"),
                        ),
                        Text(
                          DateFormat("MMM")
                              .format(widget.event.start)
                              .toUpperCase(),
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                              color: TrailAppSettings.third,
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
                      // Featured Tag
                      Visibility(
                        visible: widget.event.featured,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 9.0),
                          margin: EdgeInsets.symmetric(vertical: 4.0),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              color: Color(0xffffcb55)),
                          child: Text(
                            "Featured".toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      // Event Name
                      Container(
                        child: Text(
                          HtmlUnescape().convert(widget.event.name),
                          maxLines: 2,
                          overflow: widget.titleOverflow,
                          style: TextStyle(
                              color: TrailAppSettings.first,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      // Time
                      Row(
                        children: <Widget>[
                          // Clock Icon
                          Icon(
                            Icons.access_time,
                            color: Color(0xFF989999),
                            size: 14.0,
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          // Time
                          Text(
                            widget.event.getTimeString(),
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
                      Visibility(
                        visible: widget.event.locationName != null,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: Color(0xFF666666),
                              size: 14.0,
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Expanded(
                              child: Text(
                                widget.event.locationName != null
                                    ? widget.event.locationName
                                    : " ",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: 14.0,
                                ),
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
        ),
      ),
    );
  }
}
