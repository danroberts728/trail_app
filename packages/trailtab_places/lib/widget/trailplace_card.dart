// Copyright (c) 2020, Fermented Software.
import 'package:flutter/foundation.dart';
import 'package:trailtab_places/bloc/textbutton_stamp_bloc.dart';
import 'package:trailtab_places/bloc/trailplace_card_bloc.dart';
import 'package:trail_database/trail_database.dart';
import 'package:trailtab_places/widget/favorite_button.dart';
import 'package:trailtab_places/widget/screen_trailplace_detail.dart';
import 'package:trailtab_places/widget/stamped_place_icon.dart';
import 'package:trailtab_places/widget/textbutton_map.dart';
import 'package:trailtab_places/widget/textbutton_stamp.dart';
import 'package:trailtab_places/widget/trailplace_header.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:trail_database/domain/trail_place.dart';

/// The card used in a list of places
class TrailPlaceCard extends StatefulWidget {
  final ValueKey key;
  final TrailPlace place;

  TrailPlaceCard({this.key, @required this.place});

  @override
  State<StatefulWidget> createState() => _TrailPlaceCard();
}

class _TrailPlaceCard extends State<TrailPlaceCard> {
  TrailPlaceCardBloc _bloc;

  @override
  void initState() {
    _bloc = TrailPlaceCardBloc(TrailDatabase(), widget.place.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return StreamBuilder(
          stream: _bloc.stream,
          initialData: _bloc.trailPlaceCardInfo,
          builder: (context, snapshot) {
            var data = snapshot.data as TrailPlaceCardInfo;
            return InkWell(
              onTap: () {
                goToDetails(context, data.place);
              },
              child: Container(
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
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  data.place.featuredImgUrl,
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
                                    name: data.place.name,
                                    city: data.place.city,
                                    location: data.place.location,
                                    logo: CachedNetworkImage(
                                      imageUrl: data.place.logoUrl,
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
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
                                Container(
                                  width: constraints.maxWidth - 64.0,
                                  child: Wrap(
                                    runSpacing: 0.0,
                                    spacing: 0.0,
                                    children: [
                                      TextButton(
                                        child: Text(
                                          "DETAILS",
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).buttonColor,
                                          ),
                                        ),
                                        onPressed: () {
                                          goToDetails(context, data.place);
                                        },
                                      ),
                                      TextButtonMap(
                                        place: data.place,
                                      ),
                                      TextButtonStamp(
                                          visible: data.closeEnoughToCheckIn,
                                          bloc: TextButtonStampBloc(
                                              TrailDatabase(), data.place),
                                          place: data.place),
                                    ],
                                  ),
                                ),
                                FavoriteButton(
                                  place: data.place,
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
                        child: Visibility(
                          visible: data.checkInsCount > 0,
                          child: StampedPlaceIcon(
                            count: data.checkInsCount,
                            color: Theme.of(context).highlightColor,
                            place: data.place,
                            firstCheckIn: data.firstCheckin,
                            diameter: 75,
                            tilt: 12,
                            backgroundColor: Colors.white60,
                            dateFontSize: 7.0,
                            nameFontSize: 24.0,
                            cityFontSize: 20.0,
                            bottomDateMargin: 24,
                            padding: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void goToDetails(BuildContext context, TrailPlace place) {
    Feedback.forTap(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            settings: RouteSettings(
              name: 'Trail Place - ' + place.name,
            ),
            builder: (context) => TrailPlaceDetailScreen(place: place)));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
