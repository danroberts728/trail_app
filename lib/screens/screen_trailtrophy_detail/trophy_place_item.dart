import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/widgets/trailplace_header.dart';
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
          Expanded(
            child: Container(
              child: TrialPlaceHeader(
                name: place.name,
                categories: [place.city],
                titleFontSize: 16.0,
                categoriesFontSize: 12.0,
                titleOverflow: TextOverflow.ellipsis,
                alphaValue: 0,
                logo: CachedNetworkImage(
                  imageUrl: place.logoUrl,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  width: 25.0,
                  height: 25.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
