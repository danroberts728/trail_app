// Copyright (c) 2020, Fermented Software.
import 'package:beer_trail_app/blocs/screen_trailplace_detail_bloc.dart';
import 'package:beer_trail_database/domain/beer.dart';
import 'package:beer_trail_database/domain/on_tap_beer.dart';
import 'package:beer_trail_database/trail_database.dart';
import 'package:beer_trail_database/domain/trail_event.dart';
import 'package:beer_trail_database/domain/trail_place.dart';
import 'package:beer_trail_app/screens/screen_trailplace_detail/trailplace_beers.dart';
import 'package:beer_trail_app/screens/screen_trailplace_detail/trailplace_details.dart';
import 'package:beer_trail_app/screens/screen_trailplace_detail/trailplace_area.dart';
import 'package:beer_trail_app/screens/screen_trailplace_detail/trailplace_checkin_area.dart';
import 'package:beer_trail_app/screens/screen_trailplace_detail/trailplace_events.dart';
import 'package:beer_trail_app/screens/screen_trailplace_detail/trailplace_gallery_area.dart';
import 'package:beer_trail_app/screens/screen_trailplace_detail/trailplace_hours_area.dart';
import 'package:beer_trail_app/screens/screen_trailplace_detail/trailplace_on_tap.dart';
import 'package:beer_trail_app/util/trail_app_settings.dart';
import 'package:beer_trail_app/widgets/favorite_button.dart';
import 'package:beer_trail_app/widgets/guild_badge.dart';
import 'package:beer_trail_app/widgets/stamped_place_icon.dart';
import 'package:beer_trail_app/widgets/trailplace_header.dart';
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
  ScreenTrailPlaceDetailBloc _bloc;

  @override
  void initState() {
    _bloc = ScreenTrailPlaceDetailBloc(widget.place.id, TrailDatabase());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.stream,
      initialData: _bloc.placeDetail,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Loading"),
            ),
            body: Container(
              color: Colors.white,
              height: double.infinity,
              width: double.infinity,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        PlaceDetail placeDetail = snapshot.data;
        TrailPlace place = placeDetail.place;
        List<TrailEvent> events = placeDetail.events;
        int checkInsCount = placeDetail.checkInsCount ?? 0;
        List<OnTapBeer> taps = placeDetail.taps ?? <OnTapBeer>[];
        List<Beer> allBeers = placeDetail.place.allBeers ?? <Beer>[];

        List<Widget> tabs = [Tab(text: "Details")];
        List<Widget> tabChildren = [TrailPlaceDetails(place: place)];
        if (taps.length > 0 &&
            // Only show member tap list unless turned off in the settings
            (TrailAppSettings.showNonMemberTapList || place.isMember)) {
          tabs.add(Tab(text: "On Tap Now"));
          tabChildren.add(
            TrailPlaceOnTap(
              tapItems: taps.map((t) => TapListExpansionItem(tap: t)).toList(),
            ),
          );
        }
        if (events.length > 0) {
          tabs.add(Tab(text: "Upcoming Events"));
          tabChildren.add(TrailPlaceEvents(events: events));
        }
        if (allBeers.length > 0) {
          tabs.add(Tab(text: "Most Popular Beers"));
          tabChildren.add(TrailPlaceBeers(beers: allBeers));
        }

        return DefaultTabController(
          length: tabChildren.length,
          child: Scaffold(
            appBar: AppBar(
              title: Text(place.name),
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
                              galleryImageUrls:
                                  [place.featuredImgUrl] + place.galleryUrls,
                            ),
                            Positioned(
                              left: 16.0,
                              top: 16.0,
                              child: Visibility(
                                visible: place.isMember,
                                child: GuildBadge(),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Visibility(
                                visible: placeDetail.checkInsCount != 0,
                                child: StampedPlaceIcon(
                                  count: placeDetail.checkInsCount,
                                  place: place,
                                  firstCheckIn: placeDetail.firstCheckIn,
                                  tilt: 12,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8.0,
                              right: 16.0,
                              child: FavoriteButton(
                                place: place,
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
                                name: place.name,
                                categories: place.categories,
                                titleFontSize: 20,
                                categoriesFontSize: 16.0,
                                titleOverflow: TextOverflow.visible,
                                logo: CachedNetworkImage(
                                  imageUrl: place.logoUrl,
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
                                place: place,
                                checkInsCount: checkInsCount,
                              ),
                              // Hours Area
                              TrailPlaceArea(
                                isVisible: place.hours != null &&
                                    place.hours.length > 0,
                                child: TrailPlaceHoursArea(
                                  fontSize: 14.0,
                                  iconSize: 22.0,
                                  place: place,
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
                            labelPadding: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 22.0),
                            indicatorColor: TrailAppSettings.actionLinksColor,
                            indicatorWeight: 4.0,
                            labelColor: TrailAppSettings.subHeadingColor,
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                            tabs: tabs,
                          ),
                        ),
                        SizedBox(height: 8.0),
                      ],
                    ),
                  ),
                ];
              },
              body: TabBarView(
                children: tabChildren,
              ),
            ),
          ),
        );
      },
    );
  }
}
