// Copyright (c) 2020, Fermented Software.
import 'package:trail_database/domain/trail_place.dart';
import 'package:beer_trail_app/screens/screen_trailplace_detail/trailplace_area.dart';
import 'package:beer_trail_app/screens/screen_trailplace_detail/trailplace_external_link_area.dart';
import 'package:beer_trail_app/util/app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// List connections for a trail place
class TrailPlaceDetails extends StatelessWidget {
  final TrailPlace place;

  const TrailPlaceDetails({Key key, @required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(place == null) {
      return Center(child: Text("Loading"));
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          // Description
          TrailPlaceArea(
            bottomBorder: false,
            isVisible:
                place.description != null && place.description.isNotEmpty,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
              child: place.description == null
                  ? SizedBox()
                  : HtmlWidget(
                      place.description,
                      onTapUrl: (url) => AppLauncher().openWebsite(url),
                    ),
            ),
          ),
          SizedBox(height: 16.0),
          TrailPlaceArea(
            bottomBorder: true,
            isVisible: true,
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
            isVisible: place.phones != null && place.phones.length > 0,
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
                AppLauncher().openWebsite(place.connections['website']);
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
                AppLauncher().openFacebookPage(place.connections['facebook']);
              },
            ),
          ),
          // Twitter
          TrailPlaceArea(
            isVisible: _getUsername(place.connections['twitter']) != null,
            child: TrailPlaceExternalLinkArea(
                leadingIconData: FontAwesomeIcons.twitter,
                leadingIconSize: 22.0,
                content: _getUsername(place.connections['twitter']) == null
                    ? Container()
                    : Text(_getUsername(place.connections['twitter'])),
                onPress: () {
                  AppLauncher().openWebsite(place.connections['twitter']);
                }),
          ),
          // Instagram
          TrailPlaceArea(
            isVisible: _getUsername(place.connections['instagram']) != null,
            child: TrailPlaceExternalLinkArea(
                leadingIconData: FontAwesomeIcons.instagram,
                leadingIconSize: 20.0,
                content: _getUsername(place.connections['instagram']) == null
                    ? Container()
                    : Text(_getUsername(place.connections['instagram'])),
                onPress: () {
                  AppLauncher().openWebsite(place.connections['instagram']);
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
                      .openUntappdBrewery(place.connections['untappd']);
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
                  AppLauncher().openWebsite(place.connections['youtube']);
                }),
          ),
          // Email
          TrailPlaceArea(
              isVisible: place.emails != null && place.emails.length > 0,
              child: TrailPlaceExternalLinkArea(
                leadingIconData: Icons.email,
                content: place.emails != null && place.emails.length > 0
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
    );
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
