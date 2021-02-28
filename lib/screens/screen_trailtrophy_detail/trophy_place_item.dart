// Copyright (c) 2021, Fermented Software.
import 'package:beer_trail_database/domain/trail_place.dart';
import 'package:beer_trail_app/widgets/trailplace_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TrophyPlaceItem extends StatelessWidget {
  final TrailPlace place;
  final bool isChecked;

  const TrophyPlaceItem({Key key, @required this.place, @required this.isChecked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.2),
        ),
      ),
      child: Row(
        children: <Widget>[
          isChecked
              ? Icon(Icons.check, color: Colors.green)
              : Icon(Icons.close, color: Colors.red),
          SizedBox(width: 4.0),
          Expanded(
            child: Container(
              child: TrialPlaceHeader(
                name: place.name,
                categories: [place.city],
                titleFontSize: 18.0,
                categoriesFontSize: 16.0,
                titleOverflow: TextOverflow.ellipsis,
                alphaValue: 0,
                logo: CachedNetworkImage(
                  imageUrl: place.logoUrl,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  width: 35.0,
                  height: 35.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
