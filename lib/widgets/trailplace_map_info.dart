// Copyright (c) 2020, Fermented Software.
import 'package:beer_trail_app/screens/screen_trailplace_detail/screen_trailplace_detail.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:trail_database/domain/trail_place.dart';

/// Place information element intended for use
/// on the map screen
class TrailPlaceMapInfo extends StatefulWidget {
  final ValueKey key;
  final TrailPlace place;

  /// Default constructor.
  TrailPlaceMapInfo({this.key, @required this.place});

  @override
  State<StatefulWidget> createState() => _TrailPlaceMapInfo();
}

class _TrailPlaceMapInfo extends State<TrailPlaceMapInfo> {
  _TrailPlaceMapInfo();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Feedback.forTap(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                settings: RouteSettings(
                  name: 'Trail Place - ' + widget.place.name,
                ),
                builder: (context) =>
                    TrailPlaceDetailScreen(place: widget.place)));
      },
      child: Container(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      blurRadius: 20,
                      offset: Offset.zero,
                      color: Colors.grey.withOpacity(0.5))
                ]),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  margin: EdgeInsets.only(left: 8),
                  child: CachedNetworkImage(
                    imageUrl: widget.place.logoUrl,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    width: 40.0,
                    height: 40.0,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.only(left: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.place.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xff93654e),
                          ),
                        ),
                        Text(
                          widget.place.city,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black54,
                            fontStyle: FontStyle.italic,
                            fontSize: 14.0,
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
      ),
    );
  }
}
