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
          child: HtmlWidget(
            TrailAppSettings.privacyPolicyHtml,
            onTapUrl: (url) {
              if(url.contains('mailto:')) {
                AppLauncher().email(url.replaceFirst('mailto:', ''));
              } else {
                AppLauncher().openWebsite(url);
              }
            },
          ),
        ),
      ),
    );
  }
}
