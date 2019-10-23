import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class AppLauncher {
  static final AppLauncher _instance =
      AppLauncher._privateConstructor();
  factory AppLauncher() {
    return _instance;
  }
  AppLauncher._privateConstructor();

  void openDirections(String address) async {
    // Android
    var url = 'geo:0,0?q=$address';
    if(Platform.isIOS) {
      url = 'https://maps.apple.com/?q=$address';
    }

    if(await canLaunch(url)) {
      await launch(url);
    }
    else {
      throw 'Could not launch $url';
    }
  }

  void openFacebook(String url) async {
    var newUrl = url.replaceFirst('facebook.com', 'fb.me');
    if(await canLaunch(newUrl)) {
      await launch(newUrl);
    }
    else {
      throw 'Could not launch $url';
    }
  }

  void openWebsite(String url) async {
    launch(url);
  }
}