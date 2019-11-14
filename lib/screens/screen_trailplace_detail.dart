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

  _TrailPlaceDetailScreen(this.place);

  @override
  Widget build(BuildContext context) {
    var galleryImageUrls = List.from(this.place.galleryUrls)
      ..insert(0, this.place.featuredImgUrl);
    bool hasGalleryImages =
        galleryImageUrls != null && galleryImageUrls.length > 0;

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
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 3.0),
                child: hasGalleryImages
                    ? LayoutBuilder(builder: (context, constraints) {
                        var mainImageWidth = (constraints.maxWidth * 0.8);
                        var mainImageHeight = mainImageWidth * (9 / 16);

                        return CarouselSlider(
                          height: mainImageHeight,
                          enableInfiniteScroll: true,
                          enlargeCenterPage: true,
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
                      })
                    : SizedBox(
                        height: 0.0,
                      ),
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
                ),
              ),
              // Connection Buttons
              Container(
                color: Colors.white,
                width: double.infinity,
                margin: EdgeInsets.only(
                  bottom: 6.0,
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
                  iconSize: 16.0,
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
                  horizontal: 16.0,
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
                      carIconColor: Colors.black45,
                      iconSize: 32.0,
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
                    title: Text(
                      "Hours",
                      style: TextStyle(
                        fontSize: 22.0,
                        color: TrailAppSettings.second,
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
                    title: Text(
                      "Contact",
                      style: TextStyle(
                        fontSize: 22.0,
                        color: TrailAppSettings.second,
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
