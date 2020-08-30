import 'dart:async';
import 'dart:math';

import 'package:alabama_beer_trail/util/location_service.dart';
import 'package:alabama_beer_trail/blocs/user_checkins_bloc.dart';
import 'package:alabama_beer_trail/data/check_in.dart';
import 'package:alabama_beer_trail/screens/screen_trailplace_detail/screen_trailplace_detail.dart';
import 'package:alabama_beer_trail/util/geo_methods.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/widgets/button_check_in.dart';
import 'package:alabama_beer_trail/widgets/trailplace_action_button_widget.dart';
import 'package:alabama_beer_trail/widgets/trailplace_header.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'check_in_count_widget.dart';

import '../data/trail_place.dart';

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
  int _checkInsCount = 0;

  final _locationBloc = LocationService();
  final _userCheckinsBloc = UserCheckinsBloc();
  StreamSubscription<Point> _streamSub;
  StreamSubscription<List<CheckIn>> _checkInSubscription;

  _TrailListCard(this.place);

  @override
  void initState() {
    this._locationEnabled = _locationBloc.hasPermission;
    this._distance = _getDistance();
    _checkInSubscription = this._userCheckinsBloc.checkInStream.listen((data) {
      setState(() {
        this._checkInsCount =
            data.where((element) => element.placeId == place.id).length;
      });
    });

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
    return GestureDetector(onTap: () {
      Feedback.forTap(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              settings: RouteSettings(
                name: 'Trail Place - ' + widget.place.name,
              ),
              builder: (context) => TrailPlaceDetailScreen(place: place)));
    }, child: LayoutBuilder(builder: (context, constraints) {
      return Container(
        child: Card(
          margin:
              EdgeInsets.only(bottom: 12.0, top: 2.0, left: 8.0, right: 8.0),
          elevation: 12.0,
          child: Column(
            children: <Widget>[
              Container(
                width: constraints.maxWidth,
                height:
                    constraints.maxWidth * (9 / 16), // Force 16:9 image ratio
                padding: EdgeInsets.all(0.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      this.place.featuredImgUrl,
                    ),
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
                      color: Colors.transparent,
                      child: TrialPlaceHeader(
                        name: this.place.name,
                        leadingSpace: 4.0,
                        categories: this.place.categories,
                        logo: CachedNetworkImage(
                          imageUrl: this.place.logoUrl,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          width: 40.0,
                          height: 40.0,
                        ),
                        backgroundColor: Colors.white,
                        alphaValue: 225,
                      ),
                    ),
                    Container(
                      // Location and action buttons
                      height: 50.0,
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
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.white,
                                      size: 18.0,
                                    ),
                                    SizedBox(width: 4.0),
                                    Text(
                                      this._locationEnabled &&
                                              this.place.city != null
                                          ? this.place.city +
                                              " " +
                                              GeoMethods
                                                  .toFriendlyDistanceString(
                                                      this._distance) +
                                              " mi"
                                          : this.place.city ?? "",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14.0),
                                    ),
                                  ],
                                ),
                                CheckInCountWidget(
                                  count: _checkInsCount,
                                  visible: _checkInsCount != 0,
                                  icon: Icons.check,
                                  iconColor: Colors.white.withAlpha(200),
                                  fontColor: Colors.white.withAlpha(200),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          TrailPlaceActionButtonWidget(
                            place: this.place,
                            mapIconColor: TrailAppSettings.subHeadingColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: CheckinButton(
                  showAlways: false,
                  canCheckin: this._distance != null &&
                      this._distance <= TrailAppSettings.minDistanceToCheckin,
                  place: this.place,
                ),
              ),
            ],
          ),
        ),
      );
    }));
  }

  @override
  void dispose() {
    _streamSub.cancel();
    _checkInSubscription.cancel();
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
