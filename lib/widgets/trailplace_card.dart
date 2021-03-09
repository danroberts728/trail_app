// Copyright (c) 2020, Fermented Software.
import 'dart:async';
import 'dart:math';

import 'package:beer_trail_app/blocs/button_check_in_bloc.dart';
import 'package:beer_trail_app/blocs/trailplace_card_bloc.dart';
import 'package:beer_trail_database/trail_database.dart';
import 'package:trail_auth/trail_auth.dart';
import 'package:trail_location_service/trail_location_service.dart';
import 'package:beer_trail_app/screens/screen_trailplace_detail/screen_trailplace_detail.dart';
import 'package:beer_trail_app/util/trail_app_settings.dart';
import 'package:beer_trail_app/widgets/button_check_in.dart';
import 'package:beer_trail_app/widgets/stamped_place_icon.dart';
import 'package:beer_trail_app/widgets/trailplace_action_button_widget.dart';
import 'package:beer_trail_app/widgets/trailplace_header.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:beer_trail_database/domain/trail_place.dart';

class TrailPlaceCard extends StatefulWidget {
  final ValueKey key;
  final TrailPlace place;

  TrailPlaceCard({this.key, @required this.place});

  @override
  State<StatefulWidget> createState() => _TrailPlaceCard(place);
}

class _TrailPlaceCard extends State<TrailPlaceCard> {
  final TrailPlace place;
  double _distance = double.infinity;
  int _checkInsCount = 0;
  DateTime _firstCheckIn;

  final _locationService = TrailLocationService();
  StreamSubscription<Point> _streamSub;
  StreamSubscription<int> _checkInSubscription;

  _TrailPlaceCard(this.place);

  @override
  void initState() {
    this._distance = _getDistance();
    var bloc = TrailPlaceCardBloc(TrailDatabase(), place.id);
    _checkInsCount = bloc.checkInsCount;
    _firstCheckIn = bloc.getFirstCheckIn();
    _checkInSubscription = bloc.stream.listen((data) {
      setState(() {
        this._checkInsCount = data;
        this._firstCheckIn = bloc.getFirstCheckIn();
      });
    });

    this._streamSub = _locationService.locationStream.listen((newUserLocation) {
      setState(() {
        this._distance = _getDistance();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: () {
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
                              Expanded(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Wrap(
                                        children: <Widget>[
                                          Icon(
                                            Icons.location_on,
                                            color: Colors.white,
                                            size: 18.0,
                                          ),
                                          SizedBox(width: 4.0),
                                          // City
                                          Text(
                                            place.city + " ",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.0),
                                          ),

                                          /// Show distance if location available
                                          Visibility(
                                            visible:
                                                _locationService.lastLocation !=
                                                    null,
                                            child: Text(
                                              GeoMethods
                                                      .toFriendlyDistanceString(
                                                          _distance, TrailAppSettings.minDistanceToCheckin) +
                                                  " mi",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
                      bloc: ButtonCheckInBloc(TrailDatabase()),
                      appAuth: TrailAuth(),
                      showAlways: false,
                      place: this.place,
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 4,
                right: 4,
                child: _firstCheckIn != null
                    ? StampedPlaceIcon(
                        count: _checkInsCount,
                        place: place,
                        firstCheckIn: _firstCheckIn,
                        diameter: 75,
                        tilt: 12,
                        backgroundColor: Colors.white60,
                        dateFontSize: 7.0,
                        nameFontSize: 24.0,
                        cityFontSize: 20.0,
                        bottomDateMargin: 24,
                        padding: 8,
                      )
                    : Container(),
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
    if (_locationService.lastLocation != null) {
      return GeoMethods.calculateDistance(
          _locationService.lastLocation, this.place.location);
    } else {
      return double.infinity;
    }
  }
}
