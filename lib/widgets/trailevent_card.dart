import 'package:alabama_beer_trail/blocs/trailevent_card_bloc.dart';
import 'package:alabama_beer_trail/data/trail_event.dart';
import 'package:alabama_beer_trail/screens/screen_trailevent_detail.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';

class TrailEventCard extends StatefulWidget {
  final ValueKey key;
  final TrailEvent event;
  final double startMargin;
  final double endMargin;
  final double bottomMargin;
  final TextOverflow titleOverflow;
  final double elevation;
  final bool showImage;

  TrailEventCard(
      {this.key,
      @required this.event,
      this.startMargin = 0.0,
      this.titleOverflow = TextOverflow.ellipsis,
      this.endMargin = 0.0,
      this.elevation = 4.0,
      this.bottomMargin = 0.0,
      this.showImage = true});

  @override
  State<StatefulWidget> createState() => _TrailEventCard();
}

class _TrailEventCard extends State<TrailEventCard> {
  @override
  Widget build(BuildContext context) {
    TrailEventCardBloc _bloc = TrailEventCardBloc(widget.event.id);
    return StreamBuilder(
      stream: _bloc.stream,
      initialData: _bloc.event,
      builder: (context, snapshot) {
        TrailEvent event = snapshot.data;
        BoxDecoration boxDecoration;
        if (event.status == 'cancelled') {
          boxDecoration = BoxDecoration(
            color: Color.fromRGBO(253, 242, 242, 1),
          );
        } else if (event.featured) {
          boxDecoration = BoxDecoration(
            color: Color(0xfffff6e2),
          );
        } else {
          boxDecoration = BoxDecoration(
            color: Color(0x00025c6e),
          );
        }
        return GestureDetector(
          onTap: () {
            Feedback.forTap(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    settings:
                        RouteSettings(name: 'Trail Event - ' + event.name),
                    builder: (context) =>
                        TrailEventDetailScreen(event: event)));
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
                  decoration: boxDecoration,
                  padding: EdgeInsets.symmetric(
                    horizontal: 0.0,
                    vertical: 0.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Visibility(
                            visible: widget.event.imageUrl != null &&
                                widget.showImage,
                            child: Container(
                              width: constraints.maxWidth,
                              height: constraints.maxWidth *
                                  (9 / 16), // Force 16:9 image ratio
                              padding: EdgeInsets.all(0.0),
                              child: CachedNetworkImage(
                                imageUrl: widget.event.imageUrl ?? '',
                                progressIndicatorBuilder:
                                    (context, url, progress) => Center(
                                  child: CircularProgressIndicator(
                                    value: progress.progress,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.cover,
                                repeat: ImageRepeat.noRepeat,
                                alignment: Alignment.center,
                              ),
                            ),
                          );
                        },
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 12.0,
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
                                  // Featured/Cancelled Tag
                                  Visibility(
                                    visible: event.status == 'cancelled' || event.featured,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3.0, horizontal: 9.0),
                                      margin:
                                          EdgeInsets.symmetric(vertical: 4.0),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                          color: event.status == 'cancelled'
                                            ? Color(0xfff79191)
                                            : Color(0xffffcb55),
                                          ),
                                      child: Text(
                                        event.status == 'cancelled'
                                          ? "Cancelled".toUpperCase()
                                          : "Featured".toUpperCase(),
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
      },
    );
  }
}
