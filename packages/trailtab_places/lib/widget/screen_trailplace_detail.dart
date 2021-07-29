// Copyright (c) 2020, Fermented Software.
import 'package:flutter/foundation.dart';
import 'package:trailtab_places/bloc/screen_trailplace_detail_bloc.dart';
import 'package:trail_database/domain/beer.dart';
import 'package:trail_database/domain/on_tap_beer.dart';
import 'package:trail_database/trail_database.dart';
import 'package:trail_database/domain/trail_event.dart';
import 'package:trail_database/domain/trail_place.dart';
import 'package:trailtab_places/bloc/textbutton_stamp_bloc.dart';
import 'package:trailtab_places/util/trailtab_places_settings.dart';
import 'package:trailtab_places/widget/textbutton_map.dart';
import 'package:trailtab_places/widget/textbutton_stamp.dart';
import 'package:trailtab_places/widget/trailplace_detail_tabs/trailplace_beers.dart';
import 'package:trailtab_places/widget/trailplace_detail_tabs/trailplace_details.dart';
import 'package:trailtab_places/widget/trailplace_detail_tabs/trailplace_area.dart';
import 'package:trailtab_places/widget/trailplace_detail_tabs/trailplace_events.dart';
import 'package:trailtab_places/widget//trailplace_gallery.dart';
import 'package:trailtab_places/widget/trailplace_hours_area.dart';
import 'package:trailtab_places/widget/trailplace_detail_tabs/trailplace_ontap.dart';
import 'package:trailtab_places/widget/favorite_button.dart';
import 'package:trailtab_places/widget/guild_badge.dart';
import 'package:trailtab_places/widget/stamped_place_icon.dart';
import 'package:trailtab_places/widget/trailplace_header.dart';
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
        List<OnTapBeer> taps = placeDetail.taps ?? <OnTapBeer>[];
        List<Beer> allBeers = placeDetail.place.allBeers ?? <Beer>[];

        List<Widget> tabs = [Tab(text: "Details")];
        List<Widget> tabChildren = [TrailPlaceDetails(place: place)];
        if (taps.length > 0 &&
            // Only show member tap list unless turned off in the settings
            (TrailTabPlacesSettings().showNonMemberTapList || place.isMember)) {
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
                                child: GuildBadge(
                                  width: 42.0,
                                ),
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
                                  color: Theme.of(context).highlightColor,
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
                              TrailPlaceHeader(
                                name: place.name,
                                city: place.city,
                                location: placeDetail.place.location,
                                titleFontSize: 20,
                                cityFontSize: 16.0,
                                titleOverflow: TextOverflow.visible,
                                logo: kIsWeb
                                    ? Image.network(
                                        place.logoUrl,
                                        errorBuilder: (context, url, error) =>
                                            Icon(Icons.error),
                                        width: 60.0,
                                        height: 60.0,
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: place.logoUrl,
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                        width: 60.0,
                                        height: 60.0,
                                      ),
                              ),
                              // Action buttons
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 4.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
                                ),
                                child: Row(
                                  children: [
                                    TextButtonMap(
                                      place: place,
                                    ),
                                    TextButtonStamp(
                                      visible: true,
                                      bloc: TextButtonStampBloc(
                                          TrailDatabase(), place),
                                      place: place,
                                    ),
                                  ],
                                ),
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
                            indicatorColor: Theme.of(context).buttonColor,
                            indicatorWeight: 4.0,
                            labelColor:
                                Theme.of(context).textTheme.subtitle1.color,
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
