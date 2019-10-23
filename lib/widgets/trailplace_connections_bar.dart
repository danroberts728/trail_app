import 'package:alabama_beer_trail/util/applauncher.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TrailPlaceConnectionsBar extends StatelessWidget {
  final String websiteUrl;
  final String facebookUrl;
  final String twitterUrl;
  final String instagramUrl;
  final String youtubeUrl;
  final String untappdUrl;

  TrailPlaceConnectionsBar(
      {this.websiteUrl,
      this.facebookUrl,
      this.twitterUrl,
      this.instagramUrl,
      this.youtubeUrl,
      this.untappdUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Wrap(
        runAlignment: WrapAlignment.center,
        direction: Axis.horizontal,
        spacing: 0.0,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: <Widget>[
          Visibility(
            visible: this.websiteUrl != null,
            child: FlatButton(
              child: Icon(FontAwesomeIcons.link),
              onPressed: () => AppLauncher().openWebsite(websiteUrl),
            ),
          ),
          Visibility(
            visible: this.facebookUrl != null,
            child: FlatButton(
              child: Icon(FontAwesomeIcons.facebookF),
              onPressed: () => AppLauncher().openWebsite(facebookUrl),
            ),
          ),
          Visibility(
            visible: this.twitterUrl != null,
            child: FlatButton(
              child: Icon(FontAwesomeIcons.twitter),
              onPressed: () => AppLauncher().openWebsite(twitterUrl),
            ),
          ),
          Visibility(
            visible: this.instagramUrl != null,
            child: FlatButton(
              child: Icon(FontAwesomeIcons.instagram),
              onPressed: () => AppLauncher().openWebsite(instagramUrl),
            ),
          ),
          Visibility(
            visible: this.youtubeUrl != null,
            child: FlatButton(
              child: Icon(FontAwesomeIcons.youtube),
              onPressed: () => AppLauncher().openWebsite(youtubeUrl),
            ),
          ),
          Visibility(
            visible: this.untappdUrl != null,
            child: FlatButton(
              child: Icon(FontAwesomeIcons.untappd),
              onPressed: () => AppLauncher().openWebsite(untappdUrl),
            ),
          ),
        ],
      ),
    );
  }
}
