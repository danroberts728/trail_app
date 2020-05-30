import 'package:alabama_beer_trail/blocs/location_bloc.dart';
import 'package:alabama_beer_trail/util/geo_methods.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/widgets/button_check_in.dart';
import 'package:alabama_beer_trail/widgets/expandable_text.dart';
import 'package:alabama_beer_trail/widgets/trailplace_contact.dart';
import 'package:alabama_beer_trail/widgets/trailplace_action_button_widget.dart';
import 'package:alabama_beer_trail/widgets/trailplace_connections_bar.dart';
import 'package:alabama_beer_trail/widgets/trailplace_header.dart';
import 'package:alabama_beer_trail/widgets/trailplace_hours.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:alabama_beer_trail/widgets/check_in_count_widget.dart';
import 'package:alabama_beer_trail/blocs/user_checkins_bloc.dart';
import 'package:intl/intl.dart';

import '../data/trail_place.dart';

class TrailPlaceDetailScreen extends StatefulWidget {
  final TrailPlace place;

  const TrailPlaceDetailScreen({Key key, this.place}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TrailPlaceDetailScreen(place);
}

class _TrailPlaceDetailScreen extends State<TrailPlaceDetailScreen> {
  final TrailPlace place;

  final LocationBloc _locationBloc = LocationBloc();
  final UserCheckinsBloc _userCheckinBloc = UserCheckinsBloc();

  int _checkInsCount;
  String _overrideWording;

  _TrailPlaceDetailScreen(this.place) {
    _userCheckinBloc.checkInStream.listen((data) {
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
          var formatter = DateFormat('MMMM d, yyyy');
          if (now.difference(lastCheckin).inHours < 24) {
            _overrideWording = "Your last check-in was today";
          } else if (now.difference(lastCheckin).inDays == 1) {
            _overrideWording = "Your last check-in was yesterday";
          } else if (now.difference(lastCheckin).inDays < 7) {
            _overrideWording = "Your last check-in was this week";
          } else if (now.difference(lastCheckin).inDays < 14) {
            _overrideWording = "Your last check-in was last week";
          } else {
            _overrideWording = "Your last check-in was " + formatter.format(lastCheckin);
          }
        }
      });
    });
  }

  var _currentGalleryIndex = 0;

  @override
  Widget build(BuildContext context) {
    var galleryImageUrls = List.from(this.place.galleryUrls)
      ..insert(0, this.place.featuredImgUrl);

    return Scaffold(
      appBar: AppBar(
        title: Text(place.name),
      ),
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Carousel
              Stack(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 3.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        var mainImageWidth = constraints.maxWidth;
                        var mainImageHeight = mainImageWidth * (9 / 16);

                        return CarouselSlider(
                          onPageChanged: (index) {
                            setState(() {
                              _currentGalleryIndex = index;
                            });
                          },
                          viewportFraction: 1.0,
                          height: mainImageHeight,
                          enableInfiniteScroll: false,
                          enlargeCenterPage: false,
                          items: galleryImageUrls.map(
                            (imgUrl) {
                              return Builder(
                                builder: (context) {
                                  return Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 3.0),
                                    child: Image(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(imgUrl),
                                      width: mainImageWidth,
                                      height: mainImageHeight,
                                    ),
                                  );
                                },
                              );
                            },
                          ).toList(),
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: galleryImageUrls.length > 1,
                    child: Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: galleryImageUrls.map<Widget>((f) {
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white54,
                                ),
                                color: galleryImageUrls.indexOf(f) ==
                                        _currentGalleryIndex
                                    ? Colors.white54
                                    : Colors.black54),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              // Place Header (logo, name, categories)
              Container(
                margin: EdgeInsets.all(0.0),
                child: TrialPlaceHeader(
                  name: this.place.name,
                  categories: this.place.categories,
                  titleFontSize: 20,
                  categoriesFontSize: 16.0,
                  titleOverflow: TextOverflow.visible,
                  logo: CachedNetworkImage(
                    imageUrl: this.place.logoUrl,
                    placeholder: (context, url) => RefreshProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    width: 60.0,
                    height: 60.0,
                  ),
                ),
              ),
              // Check-in Count
              Container(
                color: Colors.white,
                width: double.infinity,
                margin: EdgeInsets.only(
                  bottom: 0.0,
                  top: 0.0,
                ),
                padding: EdgeInsets.only(
                  bottom: 8.0,
                ),
                child: CheckInCountWidget(
                  count: this._checkInsCount,
                  visible: true,
                  fontSize: 14.0,
                  iconSize: 16.0,
                  iconColor: TrailAppSettings.attentionColor,
                  fontColor: Colors.black45,
                  overrideTextNoCheckins: _overrideWording,
                  overrideTextOneCheckins: _overrideWording,
                  overrideTextManyCheckins: _overrideWording,
                ),
              ),
              // Description
              Container(
                color: Colors.white,
                width: double.infinity,
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 8.0,
                ),
                margin: EdgeInsets.all(0.0),
                child: ExpandableText(
                  text: this.place.description,
                  isExpanded: false,
                  fontSize: 16.0,
                  previewCharacterCount: 100,
                  minCharacterCountToExpand: 120,
                ),
              ),
              // Connection Buttons
              Container(
                color: Colors.white,
                width: double.infinity,
                margin: EdgeInsets.only(
                  bottom: 8.0,
                ),
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 8.0,
                ),
                child: TrailPlaceConnectionsBar(
                  websiteUrl: this.place.connections['website'],
                  facebookUrl: this.place.connections['facebook'],
                  twitterUrl: this.place.connections['twitter'],
                  instagramUrl: this.place.connections['instagram'],
                  untappdUrl: this.place.connections['untappd'],
                  youtubeUrl: this.place.connections['youtube'],
                  iconSize: 24.0,
                ),
              ),
              // Check in button
              Container(
                margin: EdgeInsets.only(
                  bottom: 6.0,
                ),
                child: CheckinButton(
                  showAlways: true,
                  place: this.place,
                  canCheckin:
                      _getDistance() < TrailAppSettings.minDistanceToCheckin,
                ),
              ),
              // Address and action buttons
              Container(
                color: Colors.white,
                margin: EdgeInsets.only(
                  bottom: 6.0,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      size: 32.0,
                      color: Colors.black54,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          place.address ?? "",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          place.city + ", " + (place.state ?? ""),
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    TrailPlaceActionButtonWidget(
                      place: this.place,
                      mapIconColor: TrailAppSettings.actionLinksColor,
                    ),
                  ],
                ),
              ),
              // Hours
              Visibility(
                visible:
                    this.place.hours != null && this.place.hours.length > 0,
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(bottom: 6.0),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                      "Hours",
                      style: TextStyle(
                        fontSize: 22.0,
                        color: TrailAppSettings.first,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                          bottom: 8.0,
                        ),
                        child: TrailPlaceHours(
                          hours: this.place.hours,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Contacts
              Visibility(
                visible: (this.place.emails != null &&
                        this.place.emails.length > 0) ||
                    (this.place.phones != null && this.place.phones.length > 0),
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(bottom: 6.0),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                      "Contact",
                      style: TextStyle(
                        fontSize: 22.0,
                        color: TrailAppSettings.first,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                          bottom: 8.0,
                        ),
                        child: TrailPlaceContact(
                          phones: this.place.phones,
                          emails: this.place.emails,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Blank Space at Bottom
              Container(
                height: 6.0,
              ),
            ],
          ),
        ),
      ),
    );
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
