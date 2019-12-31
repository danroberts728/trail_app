import 'package:alabama_beer_trail/data/trail_event.dart';
import 'package:alabama_beer_trail/util/app_launcher.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/widgets/trailevent_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';

class TrailEventDetailScreen extends StatelessWidget {
  final TrailEvent event;

  const TrailEventDetailScreen({Key key, this.event}) : super(key: key);

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
                event: this.event,
                startMargin: 0.0,
                endMargin: 0.0,
                titleOverflow: TextOverflow.visible,
                colorBarWidth: 6.0,
                elevation: 1.0,
              ),
              // Event Image
              Visibility(
                visible:
                    this.event.imageUrl != null && this.event.imageUrl != '',
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return CachedNetworkImage(
                      height: constraints.maxWidth * (9 / 16),
                      width: double.infinity,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      imageUrl: this.event.imageUrl ?? '',
                    );
                  },
                ),
              ),
              // Event Details
              Visibility(
                visible: this.event.details.isNotEmpty,
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(bottom: 6.0),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                      "Details",
                      style: TextStyle(
                        fontSize: 22.0,
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
                            Html(
                              data: this.event.details,
                              defaultTextStyle: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            Visibility(
                              visible: event.learnMoreLink != null,
                              child: SizedBox(
                                width: double.infinity,
                                child: RaisedButton(
                                  color: TrailAppSettings.actionLinksColor,
                                  textColor: Colors.white70,
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
                visible: !this.event.details.isNotEmpty,
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
                      fontSize: 22.0,
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
                        children: <Widget>[
                          Icon(
                            Icons.calendar_today,
                            size: 32.0,
                            color: Colors.black54,
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                DateFormat("EEEEE, MMMM dd, yyyy")
                                    .format(this.event.start),
                                style: TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                event.getTimeString(),
                                style: TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Location
              Visibility(
                visible: this.event.locationName != null &&
                    this.event.locationName.isNotEmpty,
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(bottom: 6.0),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                      "Where",
                      style: TextStyle(
                        fontSize: 22.0,
                        color: TrailAppSettings.mainHeadingColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            bottom: 6.0, left: 10.0, right: 10.0),
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Stack(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.location_on,
                                  size: 32.0,
                                  color: Colors.black54,
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      event.locationName,
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                        color: Color(0xFF666666),
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      event.locationAddress,
                                      style: TextStyle(
                                        color: Color(0xFF666666),
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    Text(
                                      event.locationCity +
                                          ", " +
                                          event.locationState,
                                      style: TextStyle(
                                        color: Color(0xFF666666),
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Positioned(
                              right: 10.0,
                              child: SizedBox(
                                width: 26.0,
                                child: FlatButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                    AppLauncher().openDirections(
                                        event.locationName +
                                            ", " +
                                            event.locationAddress +
                                            ", " +
                                            event.locationCity +
                                            "," +
                                            event.locationState);
                                  },
                                  child: Icon(
                                    Icons.map,
                                    color: TrailAppSettings.actionLinksColor,
                                    size: 32.0,
                                  ),
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
