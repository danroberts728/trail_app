import 'dart:async';
import 'dart:math';

import 'package:alabama_beer_trail/blocs/location_bloc.dart';
import 'package:alabama_beer_trail/screens/screen_trailplace_detail.dart';
import 'package:alabama_beer_trail/util/geomethods.dart';
import 'package:alabama_beer_trail/widgets/button_check_in.dart';
import 'package:alabama_beer_trail/widgets/trailplace_action_button_widget.dart';
import 'package:alabama_beer_trail/widgets/trailplace_header.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../util/const.dart';
import '../data/trailplace.dart';

class TrailListCard extends StatefulWidget {
  final TrailPlace place;

  TrailListCard({@required this.place});

  @override
  State<StatefulWidget> createState() => _TrailListCard(place);
}

class _TrailListCard extends State<TrailListCard> {
  final TrailPlace place;
  bool _locationEnabled = false;
  double _distance = double.infinity;

  LocationBloc _locationBloc = LocationBloc();
  StreamSubscription<Point> _streamSub;

  _TrailListCard(this.place);

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
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TrailPlaceDetailScreen(place: place)));
      },
      child: Container(
        padding: const EdgeInsets.only(top: 4.0, bottom: 12.0),
        child: Card(
          elevation: 12.0,
          child: Column(
            children: <Widget>[
              TrialPlaceHeader(
                name: this.place.name,
                categories: this.place.categories,
                logo: CachedNetworkImage(
                  imageUrl: this.place.logoUrl,
                  placeholder: (context, url) => RefreshProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  width: 40.0,
                  height: 40.0,
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
                          TrailPlaceActionButtonWidget(place: this.place),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              CheckinButton(
                canCheckin: this._distance != null && this._distance <= Constants.options.minDistanceToCheckin,
                place: this.place,
              )
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
