// Copyright (c) 2020, Fermented Software.
import 'package:flutter/foundation.dart';
import 'package:trail_database/domain/beer.dart';
import 'package:trailtab_places/widget/untappd_rating.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// List of beers that mimics untappd
class TrailPlaceBeers extends StatelessWidget {
  final List<Beer> beers;

  TrailPlaceBeers({Key key, @required this.beers}) : assert(beers != null) {
    // Sort by the number of ratings in untappd
    beers.sort((a, b) => b.untappdRatingCount.compareTo(a.untappdRatingCount));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: beers.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
            padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Powered by",
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    InkWell(
                      onTap: () {
                        launch("https://untappd.com");
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.untappd,
                            color: Color(0xffffc000),
                            size: 16.0,
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            "Untappd",
                            style: TextStyle(
                              color: Color(0xff888888),
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  "These are the most popular beers from this brewery according to Untappd users. They may not all be available on location.",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 12.0,
                ),
              ],
            ),
          );
        }
        Beer beer = beers[index - 1];
        return InkWell(
          onTap: () async {
            String launchUrl;
            String fallbackUrl =
                "https://untappd.com/beer/${beer.untappdId.toString()}";
            launchUrl = "untappd://beer/${beer.untappdId.toString()}";
            try {
              canLaunch(launchUrl).then((bool yes) {
                if (yes) {
                  launch(launchUrl);
                } else {
                  launch(fallbackUrl);
                }
              });
            } catch (err) {
              await launch(fallbackUrl);
            }
          },
          child: Container(
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
                kIsWeb
                    ? Image.network(
                        beer.labelUrl,
                        fit: BoxFit.fill,
                        height: 55.0,
                        width: 55.0,
                      )
                    : CachedNetworkImage(
                        imageUrl: beer.labelUrl,
                        height: 55.0,
                        width: 55.0,
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
                      // Beer Name
                      Text(
                        beer.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black87,
                          height: 1.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Beer Style
                      Text(
                        beer.style,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black87,
                        ),
                      ),
                      // ABV and IBU
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            beer.abv == 0
                                ? "N/A ABV"
                                : beer.abv.toString() + "% ABV",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Icon(
                            Icons.circle,
                            size: 4.0,
                            color: Colors.black87,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            beer.ibu == 0
                                ? "N/A IBU"
                                : beer.ibu.toString() + " IBU",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      UntappdRating(rating: beer.untappdRatingScore),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.exit_to_app_outlined,
                    color: Theme.of(context).textTheme.button.color,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
