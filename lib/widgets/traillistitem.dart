import 'package:alabama_beer_trail/screens/placedetail_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../blocs/user_data_bloc.dart';
import '../util/applauncher.dart';
import '../util/const.dart';
import '../data/trailplace.dart';

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
    final userDataBloc = UserDataBloc();

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TrailPlaceDetail(place: place)));
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 6.0,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  this.place.featuredImgUrl,
                ),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
              ),
              color: Color(0xFFFFFFFF),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  height: 126.0,
                ),
                Container(
                  width: double.infinity,
                  height: 58.0,
                  decoration:
                      BoxDecoration(color: Color.fromARGB(215, 255, 255, 255)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 12.0,
                      ),
                      CachedNetworkImage(
                        imageUrl: this.place.logoUrl,
                        placeholder: (context, url) =>
                            RefreshProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        width: 40.0,
                        height: 40.0,
                      ),
                      SizedBox(
                        width: 12.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            this.place.name,
                            style: TextStyle(
                              color: Color(0xff93654e),
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            this.place.categories.join(", "),
                            style: TextStyle(
                              color: Colors.black54,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 0.0,
                  ),
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
                      Text(this.place.lastClaculatedDistance <=
                            Constants.options.minDistanceToCheckin
                        ? this.place.city
                        : this.place.city +
                            " " +
                            TrailPlace.toFriendlyDistanceString(
                                place.lastClaculatedDistance) +
                            " mi",
                        style: TextStyle(color: Colors.black54),
                      ),
                      Spacer(),
                      Visibility(
                        visible: this.place.lastClaculatedDistance <=
                            Constants.options.minDistanceToCheckin,
                        child: FlatButton(
                          color: Color.fromARGB(125, 255, 255, 255),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Check In",
                                style: TextStyle(
                                  color: Constants.colors.second,
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {},
                        ),
                      ),
                      Spacer(),
                      ButtonTheme.bar(
                        child: ButtonBar(
                          children: <Widget>[
                            // Map
                            SizedBox(
                              width: 26.0,
                              child: FlatButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  String address =
                                      '${this.place.name}, ${this.place.address}, ${this.place.city}, ${this.place.state} ${this.place.zip}';
                                  AppLauncher().openDirections(address);
                                },
                                child: Icon(
                                  Icons.map,
                                  color: Constants.colors.first,
                                  size: 24.0,
                                ),
                              ),
                            ),
                            // Favorite
                            SizedBox(
                              width: 26.0,
                              child: StreamBuilder<List<String>>(
                                stream: userDataBloc.favoriteStream,
                                builder: (context, snapshot) {
                                  List<String> favorites =
                                      (snapshot.connectionState ==
                                              ConnectionState.waiting)
                                          ? userDataBloc.favorites
                                          : snapshot.data;
                                  bool isFavorite =
                                      favorites.contains(this.place.id);
                                  return FlatButton(
                                    child: Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Constants.colors.first,
                                      size: 24.0,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isFavorite = !isFavorite;
                                        Scaffold.of(context).showSnackBar(SnackBar(
                                          content: isFavorite
                                            ? Text("${this.place.name} added to favorites")
                                            : Text("${this.place.name} removed from favorites")
                                        ));
                                      });
                                      userDataBloc
                                          .toggleFavorite(this.place.id);
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
