// Copyright (c) 2020, Fermented Software.
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:trailtab_places/bloc/textbutton_stamp.dart';
import 'package:trailtab_places/bloc/trailplace_card_bloc.dart';
import 'package:trail_auth/trail_auth.dart';
import 'package:trail_database/trail_database.dart';
import 'package:trailtab_places/widget/favorite_button.dart';
import 'package:trailtab_places/widget/screen_trailplace_detail.dart';
import 'package:trailtab_places/widget/stamped_place_icon.dart';
import 'package:trailtab_places/widget/textbutton_stamp.dart';
import 'package:trailtab_places/widget/trailplace_header.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:trail_database/domain/trail_place.dart';
import 'package:url_launcher/url_launcher.dart';

class TrailPlaceCard extends StatefulWidget {
  final ValueKey key;
  final TrailPlace place;

  TrailPlaceCard({this.key, @required this.place});

  @override
  State<StatefulWidget> createState() => _TrailPlaceCard(place);
}

class _TrailPlaceCard extends State<TrailPlaceCard> {
  final TrailPlace place;
  TrailPlaceCardBloc _bloc;

  int _checkInsCount = 0;
  DateTime _firstCheckIn;

  _TrailPlaceCard(this.place);

  @override
  void initState() {
    _bloc = TrailPlaceCardBloc(TrailDatabase(), place.id);
    _checkInsCount = _bloc.checkInsCount;
    _firstCheckIn = _bloc.getFirstCheckIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var checkedInToday = _bloc.isCheckedInToday(widget.place.id);

    return LayoutBuilder(
      builder: (context, constraints) {
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
                          image: kIsWeb
                              ? NetworkImage(this.place.featuredImgUrl)
                              : CachedNetworkImageProvider(
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
                            child: TrailPlaceHeader(
                              name: this.place.name,
                              city: this.place.city,
                              location: this.place.location,
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
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Wrap(
                            spacing: 4.0,
                            children: [
                              StreamBuilder(
                                stream: _bloc.stream,
                                initialData: _bloc.checkInsCount,
                                builder: (context, snapshot) {
                                  CheckInState checkInState = checkedInToday
                                      ? CheckInState.CheckedInToday
                                      : CheckInState.NeverCheckedIn;
                                  if (_checkInsCount == 1 && checkedInToday) {
                                    checkInState = CheckInState.StampedToday;
                                  } else if (checkedInToday) {
                                    checkInState = CheckInState.CheckedInToday;
                                  } else if (_checkInsCount > 0) {
                                    checkInState = CheckInState.CheckedInBefore;
                                  }
                                  return TextButtonStamp(
                                      visible: _bloc.isCloseEnoughToCheckIn(
                                          place.location),
                                      checkInState: checkInState,
                                      isSignedIn: TrailAuth().user != null,
                                      bloc:
                                          TextButtonStampBloc(TrailDatabase()),
                                      place: place);
                                },
                              ),
                              TextButton(
                                child: Text(
                                  "DETAILS",
                                  style: TextStyle(
                                    color: Theme.of(context).buttonColor,
                                  ),
                                ),
                                onPressed: () {
                                  Feedback.forTap(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          settings: RouteSettings(
                                            name: 'Trail Place - ' +
                                                widget.place.name,
                                          ),
                                          builder: (context) =>
                                              TrailPlaceDetailScreen(
                                                  place: place)));
                                },
                              ),
                              TextButton(
                                child: Text(
                                  "MAP",
                                  style: TextStyle(
                                    color: Theme.of(context).buttonColor,
                                  ),
                                ),
                                onPressed: () async {
                                  String address =
                                      '${widget.place.name}, ${widget.place.address}, ${widget.place.city}, ${widget.place.state} ${widget.place.zip}';
                                  // Android
                                  var url = 'geo:0,0?q=$address';
                                  if (Platform.isIOS) {
                                    // iOS
                                    address = address.replaceAll(' ', '+');
                                    url = 'https://maps.apple.com/?q=$address';
                                  }

                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                              ),
                            ],
                          ),
                          FavoriteButton(
                            place: place,
                            iconSize: 36.0,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Positioned(
                  top: 16,
                  right: 4,
                  child: _firstCheckIn != null
                      ? StampedPlaceIcon(
                          count: _checkInsCount,
                          color: Theme.of(context).highlightColor,
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
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
