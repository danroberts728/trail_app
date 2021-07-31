import 'package:beer_trail_admin/screens/trail_places/trail_place_edit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trail_database/trail_database.dart';

class TrailPlaceItem extends StatefulWidget {
  final TrailPlace place;

  const TrailPlaceItem({Key key, @required this.place}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _TrailPlaceItem();
}

class _TrailPlaceItem extends State<TrailPlaceItem> {
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
                builder: (context) => TrailPlaceEdit(place: widget.place)));
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            child: Card(
              margin: EdgeInsets.only(
                  bottom: 12.0, top: 2.0, left: 8.0, right: 8.0),
              elevation: 12.0,
              child: Stack(
                children: [
                  Column(
                    children: <Widget>[
                      Container(
                        width: constraints.maxWidth,
                        height: constraints.maxWidth *
                            (9 / 16), // Force 16:9 image ratio
                        padding: EdgeInsets.all(0.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: widget.place.published
                                ? Colors.green
                                : Colors.red,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(widget.place.featuredImgUrl),
                            fit: BoxFit.cover,
                            repeat: ImageRepeat.noRepeat,
                            alignment: Alignment.center,
                          ),
                          color: Color(0xFFFFFFFF),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Container(
                                color: Colors.white70,
                                // Trail place logo, name, categories
                                margin: EdgeInsets.all(0.0),
                                padding: EdgeInsets.symmetric(vertical: 6.0),
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 4.0,
                                    ),
                                    Image.network(
                                      widget.place.logoUrl,
                                      height: 40,
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            widget.place.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Color(0xff93654e),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          Text(
                                            (widget.place.categories..sort())
                                                .join(", "),
                                            overflow: TextOverflow.visible,
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              // Location
                              height: 50.0,
                              width: constraints.maxWidth,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 0.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black38,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 18.0,
                                  ),
                                  SizedBox(width: 4.0),
                                  // City
                                  Text(
                                    widget.place.city + " ",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14.0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
