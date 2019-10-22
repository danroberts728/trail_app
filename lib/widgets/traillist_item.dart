import 'dart:async';
import 'dart:math';

import 'package:alabama_beer_trail/blocs/location_bloc.dart';
import 'package:alabama_beer_trail/blocs/user_checkins_bloc.dart';
import 'package:alabama_beer_trail/screens/placedetail_screen.dart';
import 'package:alabama_beer_trail/util/check_in.dart';
import 'package:alabama_beer_trail/util/geomethods.dart';
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
  bool _locationEnabled = false;
  double _distance = double.infinity;

  LocationBloc _locationBloc = LocationBloc();
  StreamSubscription<Point> _streamSub;

  _TrailListItem(this.place);

  static const double height = 300.0;

  @override
  void initState() {
    this._locationEnabled = _locationBloc.hasPermission;
    this._distance = _getDistance();

    this._streamSub = _locationBloc.locationStream.listen((newUserLocation) {
      setState(() {
        this._locationEnabled = _locationBloc.hasPermission;
        this._distance = _getDistance();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userDataBloc = UserDataBloc();
    final userCheckinsBloc = UserCheckinsBloc();

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TrailPlaceDetail(place: place)));
      },
      child: Container(
        padding: const EdgeInsets.only(top: 4.0, bottom: 12.0),
        child: Card(
          elevation: 12.0,
          child: Column(
            children: <Widget>[
              Container(
                // Trail place logo, name, categories
                padding: EdgeInsets.symmetric(vertical: 6.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 12.0,
                    ),
                    CachedNetworkImage(
                      imageUrl: this.place.logoUrl,
                      placeholder: (context, url) => RefreshProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      width: 40.0,
                      height: 40.0,
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            this.place.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color(0xff93654e),
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            (this.place.categories..sort()).join(", "),                            
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                              color: Colors.black54,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 150.0,
                padding: EdgeInsets.all(0.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      this.place.featuredImgUrl,
                    ),
                    fit: BoxFit.cover,
                    repeat: ImageRepeat.noRepeat,
                    alignment: Alignment.center,
                  ),
                  color: Color(0xFFFFFFFF),
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      // Space for featured photo
                      height: 110.0,
                    ),
                    Container(
                      // Location and action buttons
                      height: 40.0,
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
                            size: 16.0,
                          ),
                          SizedBox(width: 4.0),
                          Text(
                            this._locationEnabled
                                ? this.place.city +
                                    " " +
                                    GeoMethods.toFriendlyDistanceString(
                                        this._distance) +
                                    " mi"
                                : this.place.city,
                            style: TextStyle(color: Colors.white),
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
                                      Icons.drive_eta,
                                      color: Colors.white60,
                                      size: 24.0,
                                    ),
                                  ),
                                ),
                                // Favorite
                                SizedBox(
                                  width: 26.0,
                                  child: StreamBuilder<Map<String, dynamic>>(
                                    stream: userDataBloc.userDataStream,
                                    builder: (context, snapshot) {
                                      List<String> favorites =
                                          (snapshot.connectionState ==
                                                  ConnectionState.waiting)
                                              ? List<String>.from(userDataBloc
                                                  .userData['favorites'])
                                              : List<String>.from(
                                                  snapshot.data['favorites']);
                                      bool isFavorite = favorites != null &&
                                          favorites.contains(this.place.id);
                                      return FlatButton(
                                        child: Icon(
                                          isFavorite
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: Colors.red,
                                          size: 24.0,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isFavorite = !isFavorite;
                                            Scaffold.of(context).showSnackBar(SnackBar(
                                                content: isFavorite
                                                    ? Text(
                                                        "${this.place.name} added to favorites")
                                                    : Text(
                                                        "${this.place.name} removed from favorites")));
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
              Visibility(
                // Check in button
                visible:
                    this._distance <= Constants.options.minDistanceToCheckin,
                child: StreamBuilder(
                    stream: userCheckinsBloc.checkInStream,
                    builder: (context, snapshot) {
                      List<CheckIn> checkInsToday =
                          (snapshot.connectionState == ConnectionState.waiting)
                              ? userCheckinsBloc.checkIns
                              : snapshot.data;
                      var now = DateTime.now();
                      var today = DateTime(now.year, now.month, now.day);

                      bool isCheckedIn = checkInsToday.any((e) =>
                          e.placeId == this.place.id &&
                          DateTime(e.timestamp.year, e.timestamp.month,
                                  e.timestamp.day) ==
                              today);
                      return SizedBox(
                        height: 50.0,
                        width: double.infinity,
                        child: RaisedButton(
                          elevation: 8.0,
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          color: Constants.colors.second.withAlpha(200),
                          disabledColor: Constants.colors.fourth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                  isCheckedIn
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  color: Colors.white),
                              SizedBox(
                                width: 12.0,
                              ),
                              Text(
                                isCheckedIn
                                    ? "You have checked in today!"
                                    : "Tap to Check In!",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          onPressed: isCheckedIn
                              ? null
                              : () {
                                  userCheckinsBloc.checkIn(this.place.id);
                                },
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _streamSub.cancel();
    super.dispose();
  }

  double _getDistance() {
    if (_locationBloc.hasPermission) {
      return GeoMethods.calculateDistance(
          _locationBloc.lastLocation, this.place.location);
    } else {
      return double.infinity;
    }
  }
}
