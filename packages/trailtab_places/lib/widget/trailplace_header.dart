import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trail_location_service/trail_location_service.dart';
import 'package:trailtab_places/util/trailtab_places_settings.dart';

class TrailPlaceHeader extends StatefulWidget {
  final Widget logo;
  final String name;
  final String city;
  final Point<num> location;
  final double titleFontSize;
  final double cityFontSize;
  final TextOverflow titleOverflow;
  final Color backgroundColor;
  final int alphaValue;
  final bool showDistance;

  TrailPlaceHeader({
    @required this.logo,
    @required this.name,
    @required this.city,
    @required this.location,
    this.titleFontSize = 16.0,
    this.cityFontSize = 14.0,
    this.titleOverflow = TextOverflow.ellipsis,
    this.backgroundColor = Colors.white,
    this.alphaValue = 255,
    this.showDistance = true,
  });

  @override
  State<StatefulWidget> createState() => _TrailPlaceHeader();
}

class _TrailPlaceHeader extends State<TrailPlaceHeader> {
  final _locationService = TrailLocationService();

  @override
  Widget build(BuildContext context) {
    return Container(
      // Trail place logo, name, categories
      margin: EdgeInsets.all(0.0),
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      decoration: BoxDecoration(
        border: null,
        color: widget.backgroundColor.withAlpha(widget.alphaValue),
      ),
      child: Row(
        children: <Widget>[
          widget.logo,
          SizedBox(
            width: 12.0,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget.name,
                  overflow: widget.titleOverflow,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: widget.titleFontSize,
                    color: Theme.of(context).textTheme.headline1.color,
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  children: <Widget>[
                    // City
                    Text(
                      widget.city + " ",
                      style: TextStyle(
                        fontSize: widget.cityFontSize,
                        color: Colors.grey[600],
                      ),
                    ),

                    /// Show distance if location available
                    StreamBuilder(
                        stream: TrailLocationService().locationStream,
                        initialData: TrailLocationService().lastLocation,
                        builder: (context, snapshot) {
                          var distance = GeoMethods.calculateDistance(
                              widget.location, snapshot.data);
                          return Visibility(
                            visible: _locationService.lastLocation != null && widget.showDistance,
                            child: Text(
                              GeoMethods.toFriendlyDistanceString(
                                      distance,
                                      TrailTabPlacesSettings()
                                          .minDistanceToCheckIn) +
                                  " mi",
                              style: TextStyle(
                                fontSize: widget.cityFontSize,
                                color: Colors.grey[600],
                              ),
                            ),
                          );
                        })
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
