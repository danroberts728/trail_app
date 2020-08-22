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
  final double bottomMargin;
  final TextOverflow titleOverflow;
  final double elevation;
  final bool showImage;

  TrailEventCard(
      {@required this.event,
      this.startMargin = 0.0,
      this.titleOverflow = TextOverflow.ellipsis,
      this.endMargin = 0.0,
      this.elevation = 4.0,
      this.bottomMargin = 4.0,
      this.showImage = true});

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
          bottom: widget.bottomMargin,
        ),
        child: Card(
          elevation: widget.elevation,
          child: Container(
              decoration: BoxDecoration(
                color: widget.event.featured
                    ? Color(0xfffff6e2)
                    : Color(0x00025c6e),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 0.0,
                vertical: 0.0,
              ),
              child: Column(
                children: <Widget>[
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Visibility(
                        visible:
                            widget.event.imageUrl != null && widget.showImage,
                        child: Container(
                          width: constraints.maxWidth,
                          height: constraints.maxWidth *
                              (9 / 16), // Force 16:9 image ratio
                          padding: EdgeInsets.all(0.0),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                widget.event.imageUrl ?? '',
                              ),
                              fit: BoxFit.cover,
                              repeat: ImageRepeat.noRepeat,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: widget.event.imageUrl == null
                        ? 16.0
                        : 4.0,
                      horizontal: 8.0,
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
                                      fontSize: 12.0,
                                      height: 1.0,
                                      color: TrailAppSettings.third,
                                      fontFamilyFallback: ["Arial Narrow"],
                                      fontFamily: "Roboto"),
                                ),
                                Text(
                                  DateFormat("dd")
                                      .format(widget.event.start)
                                      .toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 18.0,
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
                                      fontSize: 14.0,
                                      height: 1.0,
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      color: Color(0xffffcb55)),
                                  child: Text(
                                    "Featured".toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              // Event Name
                              Container(
                                child: Text(
                                  HtmlUnescape().convert(widget.event.name),
                                  maxLines: 1,
                                  overflow: widget.titleOverflow,
                                  style: TextStyle(
                                    color: TrailAppSettings.first,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    height: 1.0,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2.0,
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
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 2.0,
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
                                          fontSize: 12.0,
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
                ],
              )),
        ),
      ),
    );
  }
}
