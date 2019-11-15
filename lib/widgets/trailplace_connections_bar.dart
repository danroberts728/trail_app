import 'package:alabama_beer_trail/util/app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TrailPlaceConnectionsBar extends StatelessWidget {
  final String websiteUrl;
  final String facebookUrl;
  final String twitterUrl;
  final String instagramUrl;
  final String youtubeUrl;
  final String untappdUrl;
  final double iconSize;

  TrailPlaceConnectionsBar(
      {this.websiteUrl,
      this.facebookUrl,
      this.twitterUrl,
      this.instagramUrl,
      this.youtubeUrl,
      this.untappdUrl,
      this.iconSize,});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: null,
        color: Colors.white,
      ),
      margin: EdgeInsets.all(0.0),
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.start,
        children: <Widget>[
          Visibility(
            visible: this.websiteUrl != null && this.websiteUrl.isNotEmpty,
            child: ButtonTheme(
              minWidth: 40.0,
              child: FlatButton(
                child: Icon(
                  FontAwesomeIcons.link,
                  size: iconSize,
                  color: Color(0xff777777),
                ),
                onPressed: () => AppLauncher().openWebsite(websiteUrl),
              ),
            ),
          ),
          Visibility(
            visible: this.facebookUrl != null && this.facebookUrl.isNotEmpty,
            child: ButtonTheme(
              minWidth: 40.0,
              child: FlatButton(
                child: Icon(
                  FontAwesomeIcons.facebookF,
                  size: iconSize,
                  color: Color(0xff3b5998),
                ),
                onPressed: () => AppLauncher().openFacebook(facebookUrl),
              ),
            ),
          ),
          Visibility(
            visible: this.twitterUrl != null && this.twitterUrl.isNotEmpty,
            child: ButtonTheme(
              minWidth: 40.0,
              child: FlatButton(
                child: Icon(
                  FontAwesomeIcons.twitter,
                  size: iconSize,
                  color: Color(0xff38a1f3),
                ),
                onPressed: () => AppLauncher().openWebsite(twitterUrl),
              ),
            ),
          ),
          Visibility(
            visible: this.instagramUrl != null && this.instagramUrl.isNotEmpty,
            child: ButtonTheme(
              minWidth: 40.0,
              child: FlatButton(
                child: Icon(
                  FontAwesomeIcons.instagram,
                  size: iconSize,
                  color: Color(0xff8a3ab9),
                ),
                onPressed: () => AppLauncher().openWebsite(instagramUrl),
              ),
            ),
          ),
          Visibility(
            visible: this.youtubeUrl != null && this.youtubeUrl.isNotEmpty,
            child: ButtonTheme(
              minWidth: 40.0,
              child: FlatButton(
                child: Icon(
                  FontAwesomeIcons.youtube,
                  size: iconSize,
                  color: Color(0xff0000ff),
                ),
                onPressed: () => AppLauncher().openWebsite(youtubeUrl),
              ),
            ),
          ),
          Visibility(
            visible: false, // For now
            child: ButtonTheme(
              minWidth: 40.0,
              child: FlatButton(
                child: Icon(
                  FontAwesomeIcons.untappd,
                  size: iconSize,
                  color: Color(0xffffc000),
                ),
                onPressed: () => AppLauncher().openWebsite(untappdUrl),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
