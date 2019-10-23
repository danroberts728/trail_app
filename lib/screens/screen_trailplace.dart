import 'package:alabama_beer_trail/blocs/location_bloc.dart';
import 'package:alabama_beer_trail/util/const.dart';
import 'package:alabama_beer_trail/util/geomethods.dart';
import 'package:alabama_beer_trail/widgets/checkin_button.dart';
import 'package:alabama_beer_trail/widgets/trailplace_action_button_widget.dart';
import 'package:alabama_beer_trail/widgets/trailplace_connections_bar.dart';
import 'package:alabama_beer_trail/widgets/trailplace_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../data/trailplace.dart';

class TrailPlaceScreen extends StatefulWidget {
  final TrailPlace place;

  const TrailPlaceScreen({Key key, this.place}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TrailPlaceScreen(place);
}

class _TrailPlaceScreen extends State<TrailPlaceScreen> {
  final TrailPlace place;

  final LocationBloc _locationBloc = LocationBloc();

  double _galleryImageWidth;
  double _galleryImageHeight;

  _TrailPlaceScreen(this.place);

  @override
  Widget build(BuildContext context) {
    _galleryImageHeight = MediaQuery.of(context).size.height;
    _galleryImageWidth = MediaQuery.of(context).size.width;

    var galleryImageUrls = List.from(this.place.galleryUrls);
    bool hasGalleryImages =
        galleryImageUrls != null && galleryImageUrls.length > 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(place.name),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 5.0),
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              hasGalleryImages
                  ? CarouselSlider(
                      enableInfiniteScroll: true,
                      enlargeCenterPage: true,
                      height: 150.0,
                      items: galleryImageUrls.map(
                        (imgUrl) {
                          return Builder(
                            builder: (context) {
                              return Container(
                                width: _galleryImageHeight,
                                height: _galleryImageWidth,
                                child: Image(
                                  fit: BoxFit.fitWidth,
                                  image: NetworkImage(imgUrl),
                                  width: _galleryImageWidth,
                                  height: _galleryImageHeight,
                                ),
                              );
                            },
                          );
                        },
                      ).toList(),
                    )
                  : SizedBox(
                      height: 0.0,
                    ),
              TrialPlaceHeader(
                name: this.place.name,
                categories: this.place.categories,
                textSizeMultiplier: 1.3,
                titleOverflow: TextOverflow.visible,
                logo: CachedNetworkImage(
                  imageUrl: this.place.logoUrl,
                  placeholder: (context, url) => RefreshProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  width: 60.0,
                  height: 60.0,
                ),
              ),
              _getDistance() < Constants.options.minDistanceToCheckin
                  ? CheckinButton(
                      place: this.place,
                      canCheckin: _getDistance() <
                          Constants.options.minDistanceToCheckin,
                    )
                  : Divider(
                      color: Constants.colors.second,
                    ),
              Container(
                margin: EdgeInsets.symmetric(
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
                          place.address,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          place.city + ", " + place.state,
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
              Divider(
                color: Constants.colors.second,
              ),
              ExpansionTile(
                title: Text("Connections"),
                children: <Widget>[
                  TrailPlaceConnectionsBar(
                    websiteUrl: this.place.connections['website'],
                    facebookUrl: this.place.connections['facebook'],
                    twitterUrl: this.place.connections['twitter'],
                    instagramUrl: this.place.connections['instagram'],
                    untappdUrl: this.place.connections['untappd'],
                    youtubeUrl: this.place.connections['youtube'],
                  ),
                ],
              ),
              ExpansionTile(                
                title: Text("Description"),
                initiallyExpanded: true,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(this.place.description ?? "",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 16.0,                        
                      ),
                    ),
                    
                  ),
                ],
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
