// Copyright (c) 2020, Fermented Software.
import 'package:alabama_beer_trail/util/app_launcher.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class ScreenPrivacyPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy Policy"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              HtmlWidget(
                '<p><em>This policy may be updated at any time. The latest version can be found <a href="https://freethehops.org/app/alabama-beer-trail-privacy-policy/">here</a></em>.</p>',
                onTapUrl: _onTapUrl,
              ),
              HtmlWidget(
                TrailAppSettings.privacyPolicyHtml,
                onTapUrl: _onTapUrl,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTapUrl(url) {
    if (url.contains('mailto:')) {
      AppLauncher().email(url.replaceFirst('mailto:', ''));
    } else {
      AppLauncher().openWebsite(url);
    }
  }
}
