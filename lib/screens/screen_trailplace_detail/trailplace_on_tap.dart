// Copyright (c) 2020, Fermented Software.
import 'package:alabama_beer_trail/data/on_tap_beer.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// UI element for a list of taps at a trail place
class TrailPlaceOnTap extends StatelessWidget {
  /// The place ID for the taps
  final List<OnTapBeer> taps;

  const TrailPlaceOnTap({Key key, @required this.taps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: taps.length,
      itemBuilder: (context, index) {
        OnTapBeer tap = taps[index];
        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.black12,
                width: 0.5,
              ),
            ),
          ),
          padding: EdgeInsets.only(bottom: 8.0),
          margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: tap.logoUrl,
                height: 75.0,
                width: 75.0,
                fit: BoxFit.fill,
              ),
              SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brewery Name
                    Text(
                      tap.manufacturer,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black87,
                        height: 1.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    // Beer Name
                    Text(
                      tap.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: TrailAppSettings.mainHeadingColor,
                        height: 1.1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Beer Style
                    Text(
                      tap.style != "" ? tap.style : "Unknown Style",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black87,
                        fontStyle: tap.style != ""
                            ? FontStyle.normal
                            : FontStyle.italic,
                      ),
                    ),
                    // ABV and IBU
                    Wrap(
                      children: [
                        Visibility(
                          visible: tap.abv != null && tap.abv != "",
                          child: Text(
                            "ABV ${tap.abv}%",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: tap.abv != null && tap.abv != "",
                          child: SizedBox(width: 12.0),
                        ),
                        Visibility(
                          visible: tap.ibu != null && tap.ibu != 0,
                          child: Text(
                            "IBU ${tap.ibu.toString()}",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
