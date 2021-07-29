import 'package:flutter/material.dart';
import 'package:trail_database/domain/trail_place.dart';
import 'package:trailtab_places/trailtab_places.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ScreenFeedback extends StatefulWidget {
  final TrailPlace place;

  const ScreenFeedback({Key key, @required this.place}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ScreenFeedback();
}

class _ScreenFeedback extends State<ScreenFeedback> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leave Feedback"),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TrailPlaceHeader(
                name: widget.place.name,
                city: widget.place.city,
                location: widget.place.location,
                titleFontSize: 20,
                cityFontSize: 16.0,
                titleOverflow: TextOverflow.visible,
                logo: CachedNetworkImage(
                  imageUrl: widget.place.logoUrl,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  width: 40.0,
                  height: 40.0,
                ),
              ),
              Divider(),
              Form(
                child: TextFormField(
                  maxLines: 10,
                  minLines: 3,
                  decoration: InputDecoration(
                    hintText: "Leave your comments here.",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Divider(),
              ScreenFeedback(place: widget.place),
            ],
          ),
        ),
      ),
    );
  }
}
