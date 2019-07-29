import 'package:beer_trail_app/util/const.dart';
import 'package:flutter/material.dart';
import '../data/trailplace.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TrailListItem extends StatefulWidget {
  final TrailPlace place;

  TrailListItem({@required this.place});

  @override
  State<StatefulWidget> createState() => _TrailListItem(place);
}

class _TrailListItem extends State<TrailListItem> {
  final TrailPlace place;

  _TrailListItem(this.place);

  static const double height = 300.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          //Navigator.push(context,
          //    MaterialPageRoute(builder: (context) => PlaceDetail(place2)));
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 6.0,
            child: Container(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                children: <Widget>[
                  // Featured Image
                  SizedBox(
                    height: 150.0,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: CachedNetworkImage(
                              imageUrl: this.place.featuredImgUrl,
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              width: 300.0,
                              height: 150.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Logo, Name
                  Container(
                      padding: const EdgeInsets.only(
                          left: 8.0, bottom: 0.0, top: 16.0),
                      alignment: AlignmentDirectional.bottomStart,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 40.0,
                            width: 40.0,
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  top: 0.0,
                                  left: 0.0,
                                  right: 0.0,
                                  child: FittedBox(
                                    child: CachedNetworkImage(
                                      imageUrl: this.place.logoUrl,
                                      placeholder: (context, url) =>
                                          RefreshProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      width: 50.0,
                                      height: 50.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Spacer
                          SizedBox(
                            width: 12.0,
                          ),
                          // Name and Categories
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                this.place.name,
                                style: TextStyle(
                                    color: Color(0xff93654e),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                              Text(this.place.categories.join(", "),
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontStyle: FontStyle.italic))
                            ],
                          ),
                        ],
                      )),
                  // Address and distance
                  Container(
                    padding: const EdgeInsets.only(left: 8.0),
                    alignment: AlignmentDirectional.bottomStart,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          color: Colors.black54,
                          size: 16.0,
                        ),
                        SizedBox(width: 4.0),
                        Text(
                            this.place.lastClaculatedDistance < Constants.options.minDistanceToCheckin
                                ? this.place.city
                                : this.place.city +
                                    " " +
                                    TrailPlace.toFriendlyDistanceString(place.lastClaculatedDistance) +
                                    " mi",
                            style: TextStyle(color: Colors.black54)),
                        Spacer(),
                        ButtonTheme.bar(
                          child: ButtonBar(
                            children: <Widget>[
                              FlatButton(
                                  child: Text("Directions".toUpperCase(),
                                      semanticsLabel:
                                          "Share ${this.place.name}"),
                                  textColor: Colors.amber.shade500,
                                  onPressed: () {
                                    print('pressed');
                                  })
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
