// Copyright (c) 2020, Fermented Software.
import 'dart:async';

import 'package:alabama_beer_trail/blocs/screen_trailplace_detail_bloc.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/screens/screen_trailplace_detail/trailplace_details.dart';
import 'package:alabama_beer_trail/screens/screen_trailplace_detail/trailplace_area.dart';
import 'package:alabama_beer_trail/screens/screen_trailplace_detail/trailplace_beers.dart';
import 'package:alabama_beer_trail/screens/screen_trailplace_detail/trailplace_checkin_area.dart';
import 'package:alabama_beer_trail/screens/screen_trailplace_detail/trailplace_events.dart';
import 'package:alabama_beer_trail/screens/screen_trailplace_detail/trailplace_gallery_area.dart';
import 'package:alabama_beer_trail/screens/screen_trailplace_detail/trailplace_hours_area.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/widgets/favorite_button.dart';
import 'package:alabama_beer_trail/widgets/guild_badge.dart';
import 'package:alabama_beer_trail/widgets/trailplace_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Detail screen of a trail place
class TrailPlaceDetailScreen extends StatefulWidget {
  final TrailPlace place;

  const TrailPlaceDetailScreen({Key key, @required this.place})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TrailPlaceDetailScreen();
}

class _TrailPlaceDetailScreen extends State<TrailPlaceDetailScreen>
    with TickerProviderStateMixin {
  int _checkInsCount = 0;
  TrailPlace _place;
  List<Widget> _tabList;
  List<Widget> _tabChildren;
  List<String> _galleryImageUrls;
  ScreenTrailPlaceDetailBloc _bloc;
  StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();
    _place = widget.place;
    _bloc = ScreenTrailPlaceDetailBloc(widget.place);
    _checkInsCount = _bloc.placeDetail.checkInsCount;
    _streamSubscription = _bloc.stream.listen(_onPlaceUpdate);
    _tabList = [Tab(text: "Details")];
    _tabChildren = [
      TrailPlaceDetails(place: _place),
    ];
    _galleryImageUrls = List.from(_place.galleryUrls)
      ..insert(0, _place.featuredImgUrl);
    if (_bloc.placeHasUpcomingEvents()) {
      _tabList.add(Tab(text: "Events"));
      _tabChildren.add(TrailPlaceEvents(locationTaxonomy: _place.locationTaxonomy));
    }
    if (_place.allBeers.isNotEmpty) {
      _tabList.add(Tab(text: "Beers"));
      _tabChildren.add(TrailPlaceBeers(beers: _place.allBeers));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabList.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_place.name),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    // Gallery with Guild badge and favorite button
                    Stack(
                      children: <Widget>[
                        TrailPlaceGallery(
                          galleryImageUrls: _galleryImageUrls,
                        ),
                        Positioned(
                          left: 16.0,
                          top: 16.0,
                          child: Visibility(
                            visible: _place.isMember,
                            child: GuildBadge(),
                          ),
                        ),
                        Positioned(
                          bottom: 8.0,
                          right: 16.0,
                          child: FavoriteButton(
                            place: _place,
                            iconSize: 36.0,
                          ),
                        ),
                      ],
                    ),
                    // Other header info with margins
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 4.0,
                      ),
                      child: Column(
                        children: <Widget>[
                          // Place Header (logo, name, categories)
                          TrialPlaceHeader(
                            name: _place.name,
                            categories: _place.categories,
                            titleFontSize: 20,
                            categoriesFontSize: 16.0,
                            titleOverflow: TextOverflow.visible,
                            logo: CachedNetworkImage(
                              imageUrl: _place.logoUrl,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                          value: downloadProgress.progress),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              width: 60.0,
                              height: 60.0,
                            ),
                          ),
                          // Check-in Area
                          TrailPlaceCheckinArea(
                            place: _place,
                            checkInsCount: _checkInsCount,
                          ),
                          Divider(
                            color: TrailAppSettings.attentionColor,
                          ),
                          // Hours Area
                          TrailPlaceArea(
                            isVisible:
                                _place.hours != null && _place.hours.length > 0,
                            child: TrailPlaceHoursArea(
                              fontSize: 14.0,
                              iconSize: 22.0,
                              place: _place,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    // Tab Bar
                    Center(
                      child: TabBar(
                        isScrollable: true,
                        labelPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 22.0),
                        indicatorColor: TrailAppSettings.actionLinksColor,
                        indicatorWeight: 4.0,
                        labelColor: TrailAppSettings.subHeadingColor,
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                        tabs: _tabList,
                      ),
                    ),
                    SizedBox(height: 8.0),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: _tabChildren,
          ),
        ),
      ),
    );
  }

  void _onPlaceUpdate(PlaceDetail event) {
    setState(() {
      _place = event.place;
      _checkInsCount = event.checkInsCount;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }
}
