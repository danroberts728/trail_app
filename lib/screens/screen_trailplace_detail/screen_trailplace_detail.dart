import 'dart:async';

import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/screens/screen_trailplace_detail/trailplace_area.dart';
import 'package:alabama_beer_trail/screens/screen_trailplace_detail/trailplace_checkin_area.dart';
import 'package:alabama_beer_trail/screens/screen_trailplace_detail/trailplace_external_link_area.dart';
import 'package:alabama_beer_trail/screens/screen_trailplace_detail/trailplace_gallery_area.dart';
import 'package:alabama_beer_trail/screens/screen_trailplace_detail/trailplace_hours_area.dart';
import 'package:alabama_beer_trail/util/app_launcher.dart';
import 'package:alabama_beer_trail/widgets/expandable_text.dart';
import 'package:alabama_beer_trail/widgets/trailplace_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:alabama_beer_trail/blocs/user_checkins_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class TrailPlaceDetailScreen extends StatefulWidget {
  final TrailPlace place;

  const TrailPlaceDetailScreen({Key key, this.place}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TrailPlaceDetailScreen(place);
}

class _TrailPlaceDetailScreen extends State<TrailPlaceDetailScreen> {
  final TrailPlace place;

  final UserCheckinsBloc _userCheckinBloc = UserCheckinsBloc();

  StreamSubscription _checkinStreamSubscription;

  int _checkInsCount;
  String _overrideWording;

  _TrailPlaceDetailScreen(this.place) {
    _checkinStreamSubscription = _userCheckinBloc.checkInStream.listen((data) {
      setState(() {
        var sortedCheckIns = data
            .where((element) => element.placeId == place.id)
            .toList()
            .map((e) => e.timestamp)
            .toList()
              ..sort((a, b) {
                return b.compareTo(a);
              });
        this._checkInsCount = sortedCheckIns.length;
        if (_checkInsCount == 0) {
          _overrideWording = "You have never checked-in";
        } else {
          var lastCheckin = sortedCheckIns[0];
          DateTime now = DateTime.now();
          var formatter = DateFormat('MMM d, yyyy');
          if (now.difference(lastCheckin).inHours < 24) {
            _overrideWording = "Your last check-in was today";
          } else if (now.difference(lastCheckin).inDays == 1) {
            _overrideWording = "Your last check-in was yesterday";
          } else if (now.difference(lastCheckin).inDays < 7) {
            _overrideWording = "Your last check-in was this week";
          } else if (now.difference(lastCheckin).inDays < 14) {
            _overrideWording = "Your last check-in was last week";
          } else {
            _overrideWording =
                "Last check-in was " + formatter.format(lastCheckin);
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> galleryImageUrls = List.from(this.place.galleryUrls)
      ..insert(0, this.place.featuredImgUrl);

    return Scaffold(
      appBar: AppBar(
        title: Text(place.name),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Carousel
              TrailPlaceGallery(
                galleryImageUrls: galleryImageUrls,
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 4.0,
                ),
                child: Column(
                  children: <Widget>[
                    // Place Header (logo, name, categories)
                    TrialPlaceHeader(
                      name: this.place.name,
                      categories: this.place.categories,
                      titleFontSize: 20,
                      categoriesFontSize: 16.0,
                      titleOverflow: TextOverflow.visible,
                      logo: CachedNetworkImage(
                        imageUrl: this.place.logoUrl,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        width: 60.0,
                        height: 60.0,
                      ),
                    ),
                    // Check-in Area
                    TrailPlaceCheckinArea(
                      place: widget.place,
                      checkinsCount: _checkInsCount,
                      overrideWording: _overrideWording,
                    ),
                    // Description
                    TrailPlaceArea(
                      isVisible: place.description != null,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 4.0),
                        child: ExpandableText(
                          fontSize: 16.0,
                          isExpanded: false,
                          minCharacterCountToExpand: 140,
                          previewCharacterCount: 120,
                          text: place.description,
                        ),
                      ),
                    ),
                    // Hours Area
                    TrailPlaceArea(
                      isVisible: place.hours != null && place.hours.length > 0,
                      child: TrailPlaceHoursArea(
                        place: place,
                      ),
                    ),
                    // Address Area
                    TrailPlaceArea(
                      isVisible: place.address != null,
                      child: TrailPlaceExternalLinkArea(
                        leadingIconData: Icons.directions,
                        onPress: () {
                          String address =
                              '${place.name}, ${place.address}, ${place.city}, ${place.state} ${place.zip}';
                          AppLauncher().openDirections(address);
                        },
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              place.address ?? "",
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              place.city + ", " + (place.state ?? ""),
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Phone
                    TrailPlaceArea(
                      isVisible:
                          place.phones != null && place.phones.length > 0,
                      child: TrailPlaceExternalLinkArea(
                        leadingIconData: Icons.phone,
                        content: place.phones != null && place.phones.length > 0
                            ? Text(place.phones.values.first)
                            : Text(""),
                        onPress: () {
                          AppLauncher().call(place.phones.values.first);
                        },
                      ),
                    ),
                    // URL Link
                    TrailPlaceArea(
                      isVisible: place.connections['website'] != null &&
                          "" != place.connections['website'],
                      child: TrailPlaceExternalLinkArea(
                        leadingIconData: FontAwesomeIcons.link,
                        leadingIconSize: 22.0,
                        content: Text(
                          (place.connections['website'] ?? "")
                              .replaceAll("http://", "")
                              .replaceAll("https://", "")
                              .replaceAll(RegExp(r"/$"), ""),
                          overflow: TextOverflow.fade,
                        ),
                        onPress: () {
                          AppLauncher()
                              .openWebsite(place.connections['website']);
                        },
                      ),
                    ),
                    // Facebook
                    TrailPlaceArea(
                      isVisible: place.connections['facebook'] != null &&
                          "" != place.connections['facebook'],
                      child: TrailPlaceExternalLinkArea(
                        leadingIconData: FontAwesomeIcons.facebookF,
                        leadingIconSize: 22.0,
                        content: Text(place.name) ?? "",
                        onPress: () {
                          AppLauncher()
                              .openFacebook(place.connections['facebook']);
                        },
                      ),
                    ),
                    // Twitter
                    TrailPlaceArea(
                      isVisible:
                          _getUsername(place.connections['twitter']) != null,
                      child: TrailPlaceExternalLinkArea(
                          leadingIconData: FontAwesomeIcons.twitter,
                          leadingIconSize: 22.0,
                          content: _getUsername(place.connections['twitter']) ==
                                  null
                              ? Container()
                              : Text(
                                  _getUsername(place.connections['twitter'])),
                          onPress: () {
                            AppLauncher()
                                .openWebsite(place.connections['twitter']);
                          }),
                    ),
                    // Instagram
                    TrailPlaceArea(
                      isVisible:
                          _getUsername(place.connections['instagram']) != null,
                      child: TrailPlaceExternalLinkArea(
                          leadingIconData: FontAwesomeIcons.instagram,
                          leadingIconSize: 20.0,
                          content: _getUsername(
                                      place.connections['instagram']) ==
                                  null
                              ? Container()
                              : Text(
                                  _getUsername(place.connections['instagram'])),
                          onPress: () {
                            AppLauncher()
                                .openWebsite(place.connections['instagram']);
                          }),
                    ),
                    // untappd
                    TrailPlaceArea(
                      isVisible: place.connections['untappd'] != null &&
                          "" != place.connections['untappd'],
                      child: TrailPlaceExternalLinkArea(
                          leadingIconData: FontAwesomeIcons.untappd,
                          leadingIconSize: 20.0,
                          content: Text(place.name) ?? "",
                          onPress: () {
                            AppLauncher()
                                .openWebsite(place.connections['untappd']);
                          }),
                    ),
                    // Youtube
                    TrailPlaceArea(
                      isVisible: place.connections['youtube'] != null &&
                          "" != place.connections['youtube'],
                      child: TrailPlaceExternalLinkArea(
                          leadingIconData: FontAwesomeIcons.youtube,
                          leadingIconSize: 20.0,
                          content: Text(place.connections['youtube'] ?? ""),
                          onPress: () {
                            AppLauncher()
                                .openWebsite(place.connections['youtube']);
                          }),
                    ),
                    // Email
                    TrailPlaceArea(
                        isVisible:
                            place.emails != null && place.emails.length > 0,
                        child: TrailPlaceExternalLinkArea(
                          leadingIconData: Icons.email,
                          content:
                              place.emails != null && place.emails.length > 0
                                  ? Text(place.emails.values.first)
                                  : Text(""),
                          onPress: () {
                            AppLauncher().email(place.emails.values.first);
                          },
                        )),
                    // Blank Space at Bottom
                    Container(
                      height: 6.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _checkinStreamSubscription.cancel();
    super.dispose();
  }
}

String _getUsername(String url) {
  var twitterRegExp = RegExp("https?://(www\.)?twitter\.com/([^/]+)/?" ?? "");
  var instagramRegExp =
      RegExp("https?://(www\.)?instagram\.com/([^/]+)/?" ?? "");

  if (url == null || url.length == 0) {
    return null;
  }
  if (twitterRegExp.hasMatch(url)) {
    try {
      return "@" + twitterRegExp.firstMatch(url ?? "").group(2);
    } catch (e) {
      return null;
    }
  }
  if (instagramRegExp.hasMatch(url)) {
    try {
      return "@" + instagramRegExp.firstMatch(url ?? "").group(2);
    } catch (e) {
      return null;
    }
  }

  return "";
}
