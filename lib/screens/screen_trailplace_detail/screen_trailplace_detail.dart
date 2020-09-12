import 'package:alabama_beer_trail/blocs/screen_trailplace_detail_bloc.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/screens/screen_trailplace_detail/trailplace_area.dart';
import 'package:alabama_beer_trail/screens/screen_trailplace_detail/trailplace_checkin_area.dart';
import 'package:alabama_beer_trail/screens/screen_trailplace_detail/trailplace_external_link_area.dart';
import 'package:alabama_beer_trail/screens/screen_trailplace_detail/trailplace_gallery_area.dart';
import 'package:alabama_beer_trail/screens/screen_trailplace_detail/trailplace_hours_area.dart';
import 'package:alabama_beer_trail/util/app_launcher.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/widgets/favorite_button.dart';
import 'package:alabama_beer_trail/widgets/guild_badge.dart';
import 'package:alabama_beer_trail/widgets/trailplace_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TrailPlaceDetailScreen extends StatefulWidget {
  final TrailPlace place;

  const TrailPlaceDetailScreen({Key key, this.place}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TrailPlaceDetailScreen();
}

class _TrailPlaceDetailScreen extends State<TrailPlaceDetailScreen> {
  int _checkInsCount = 0;
  TrailPlace _place;

  ScreenTrailPlaceDetailBloc _bloc;

  @override
  void initState() {
    super.initState();
    _place = widget.place;
    _bloc = ScreenTrailPlaceDetailBloc(widget.place);
    _checkInsCount = _bloc.placeDetail.checkInsCount;
    _bloc.stream.listen(_onPlaceUpdate);
  }

  @override
  Widget build(BuildContext context) {
    List<String> galleryImageUrls = List.from(_place.galleryUrls)
      ..insert(0, _place.featuredImgUrl);

    return Scaffold(
      appBar: AppBar(
        title: Text(_place.name),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Carousel and Favorite Button
              Stack(
                children: <Widget>[
                  TrailPlaceGallery(
                    galleryImageUrls: galleryImageUrls,
                  ),
                  Positioned(
                    left: 16.0,
                    top: 16.0,
                    child: Visibility(
                      visible: _place.isMember,
                      child: GuildBadge(
                        alphaValue: 200,
                      ),
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
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        width: 60.0,
                        height: 60.0,
                      ),
                    ),
                    // Check-in Area
                    TrailPlaceCheckinArea(
                      place: _place,
                      checkInsCount: _checkInsCount,
                    ),
                    // Description
                    Divider(
                      color: TrailAppSettings.attentionColor,
                    ),
                    TrailPlaceArea(
                      isVisible: _place.description != null &&
                          _place.description.isNotEmpty,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 4.0),
                        child: _place.description == null
                            ? SizedBox()
                            : HtmlWidget(
                                _place.description,
                                onTapUrl: (url) =>
                                    AppLauncher().openWebsite(url),
                              ),
                      ),
                    ),
                    Divider(
                      color: TrailAppSettings.attentionColor,
                    ),
                    // Hours Area
                    TrailPlaceArea(
                      isVisible:
                          _place.hours != null && _place.hours.length > 0,
                      child: TrailPlaceHoursArea(
                        place: _place,
                      ),
                    ),
                    // Address Area
                    TrailPlaceArea(
                      isVisible: _place.address != null,
                      child: TrailPlaceExternalLinkArea(
                        leadingIconData: Icons.directions,
                        onPress: () {
                          String address =
                              '${_place.name}, ${_place.address}, ${_place.city}, ${_place.state} ${_place.zip}';
                          AppLauncher().openDirections(address);
                        },
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _place.address ?? "",
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              _place.city + ", " + (_place.state ?? ""),
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
                          _place.phones != null && _place.phones.length > 0,
                      child: TrailPlaceExternalLinkArea(
                        leadingIconData: Icons.phone,
                        content:
                            _place.phones != null && _place.phones.length > 0
                                ? Text(_place.phones.values.first)
                                : Text(""),
                        onPress: () {
                          AppLauncher().call(_place.phones.values.first);
                        },
                      ),
                    ),
                    // URL Link
                    TrailPlaceArea(
                      isVisible: _place.connections['website'] != null &&
                          "" != _place.connections['website'],
                      child: TrailPlaceExternalLinkArea(
                        leadingIconData: FontAwesomeIcons.link,
                        leadingIconSize: 22.0,
                        content: Text(
                          (_place.connections['website'] ?? "")
                              .replaceAll("http://", "")
                              .replaceAll("https://", "")
                              .replaceAll(RegExp(r"/$"), ""),
                          overflow: TextOverflow.fade,
                        ),
                        onPress: () {
                          AppLauncher()
                              .openWebsite(_place.connections['website']);
                        },
                      ),
                    ),
                    // Facebook
                    TrailPlaceArea(
                      isVisible: _place.connections['facebook'] != null &&
                          "" != _place.connections['facebook'],
                      child: TrailPlaceExternalLinkArea(
                        leadingIconData: FontAwesomeIcons.facebookF,
                        leadingIconSize: 22.0,
                        content: Text(_place.name) ?? "",
                        onPress: () {
                          AppLauncher()
                              .openFacebook(_place.connections['facebook']);
                        },
                      ),
                    ),
                    // Twitter
                    TrailPlaceArea(
                      isVisible:
                          _getUsername(_place.connections['twitter']) != null,
                      child: TrailPlaceExternalLinkArea(
                          leadingIconData: FontAwesomeIcons.twitter,
                          leadingIconSize: 22.0,
                          content: _getUsername(
                                      _place.connections['twitter']) ==
                                  null
                              ? Container()
                              : Text(
                                  _getUsername(_place.connections['twitter'])),
                          onPress: () {
                            AppLauncher()
                                .openWebsite(_place.connections['twitter']);
                          }),
                    ),
                    // Instagram
                    TrailPlaceArea(
                      isVisible:
                          _getUsername(_place.connections['instagram']) != null,
                      child: TrailPlaceExternalLinkArea(
                          leadingIconData: FontAwesomeIcons.instagram,
                          leadingIconSize: 20.0,
                          content:
                              _getUsername(_place.connections['instagram']) ==
                                      null
                                  ? Container()
                                  : Text(_getUsername(
                                      _place.connections['instagram'])),
                          onPress: () {
                            AppLauncher()
                                .openWebsite(_place.connections['instagram']);
                          }),
                    ),
                    // untappd
                    TrailPlaceArea(
                      isVisible: _place.connections['untappd'] != null &&
                          "" != _place.connections['untappd'],
                      child: TrailPlaceExternalLinkArea(
                          leadingIconData: FontAwesomeIcons.untappd,
                          leadingIconSize: 20.0,
                          content: Text(_place.name) ?? "",
                          onPress: () {
                            AppLauncher()
                                .openUntappd(_place.connections['untappd']);
                          }),
                    ),
                    // Youtube
                    TrailPlaceArea(
                      isVisible: _place.connections['youtube'] != null &&
                          "" != _place.connections['youtube'],
                      child: TrailPlaceExternalLinkArea(
                          leadingIconData: FontAwesomeIcons.youtube,
                          leadingIconSize: 20.0,
                          content: Text(_place.connections['youtube'] ?? ""),
                          onPress: () {
                            AppLauncher()
                                .openWebsite(_place.connections['youtube']);
                          }),
                    ),
                    // Email
                    TrailPlaceArea(
                        isVisible:
                            _place.emails != null && _place.emails.length > 0,
                        child: TrailPlaceExternalLinkArea(
                          leadingIconData: Icons.email,
                          content:
                              _place.emails != null && _place.emails.length > 0
                                  ? Text(_place.emails.values.first)
                                  : Text(""),
                          onPress: () {
                            AppLauncher().email(_place.emails.values.first);
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

  void _onPlaceUpdate(PlaceDetail event) {
    setState(() {
      _place = event.place;
      _checkInsCount = event.checkInsCount;
    });
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
