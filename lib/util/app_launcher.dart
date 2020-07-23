import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class AppLauncher {
  static final AppLauncher _instance = AppLauncher._privateConstructor();
  factory AppLauncher() {
    return _instance;
  }
  AppLauncher._privateConstructor();

  void openDirections(String address) async {
    // Android
    var url = 'geo:0,0?q=$address';
    if (Platform.isIOS) {
      // iOS
      address = address.replaceAll(' ', '+');
      url = 'https://maps.apple.com/?q=$address';
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void openFacebook(String pageId) async {
    String fbProtocolUrl;
    String fallbackUrl = "https://www.facebook.com/$pageId";
    if (Platform.isAndroid) {
      fbProtocolUrl = "fb://page/$pageId";
    } else if (Platform.isIOS) {
      fbProtocolUrl = "fb://profile/$pageId";
    } else {
      fbProtocolUrl = fallbackUrl;
    }
    try {
      canLaunch(fbProtocolUrl).then((bool yes) {
        if (yes) {
          launch(fbProtocolUrl);
        } else {
          launch(fallbackUrl);
        }
      });
    } catch (e) {
      await launch(fallbackUrl);
    }
  }

  void openWebsite(String url) async {
    launch(url);
  }

  void call(String number) async {
    String flatNumber = number.replaceAll(RegExp(r'[^0-9]'), '');
    launch("tel://$flatNumber");
  }

  void email(String address) async {
    launch("mailto:$address");
  }
}
