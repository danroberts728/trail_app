// Copyright (c) 2020, Fermented Software.
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

/// Singleton that smartly launches various apps, websites,
/// maps, emails, and phone numbers.
class AppLauncher {
  /// Singleotn Pattern
  factory AppLauncher() {
    return _instance;
  }
  static final AppLauncher _instance = AppLauncher._privateConstructor();  
  AppLauncher._privateConstructor();

  /// Opens a platform-specific map at [address]. This should
  /// work with Apple and Google Maps. If it is unable to launch
  /// find a mapping application, it will throw an exception
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

  /// Opens the untappd app to a beer with [untappdId] ID.
  /// If unable to open the app, it will open the untappd
  /// website for the beer
  void openUntappdBeer(String untappdId) async {
    String launchUrl;
    String fallbackUrl = "https://untappd.com/beer/$untappdId";
    launchUrl = "untappd://beer/$untappdId";
    try {
      canLaunch(launchUrl).then((bool yes) {
        if(yes) {
          launch(launchUrl);
        } else {
          launch(fallbackUrl);
        }
      });
    } catch(err) {
      await launch(fallbackUrl);
    }
  }

  /// Opens the untappd app to the brewery with [untappdId] ID.
  /// If unable to open the app, it will open the untappd
  /// website for the brewery
  void openUntappdBrewery(String untappdId) async {
    String launchUrl;
    String fallbackUrl = "https://untappd.com/brewery/$untappdId";
    launchUrl = "untappd://brewery/$untappdId";

    try {
      canLaunch(launchUrl).then((bool yes) {
        if (yes) {
          launch(launchUrl);
        } else {
          launch(fallbackUrl);
        }
      });
    } catch (e) {
      await launch(fallbackUrl);
    }
  }

  /// Opens the facebook app to a page with [pageId].
  /// 
  /// [pageId] is a numeric identifier that must be
  /// used for the app to link correctly. 
  /// 
  /// If unable to launch the facebook app, it should
  /// open a web browser to the facebook page.
  /// 
  /// This link sometimes help you find the ID for a 
  /// page, but it's been buggy at times:
  /// https://findmyfbid.in/
  void openFacebookPage(String pageId) async {
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

  /// Opens the web browser to [url].
  /// 
  /// This assumes the device has the
  /// ability to launch the [url]. If it
  /// does not, it may throw an exception
  void openWebsite(String url) async {
    launch(url);
  }

  /// Opens the devices phone to [number].
  /// 
  /// It does not actually call the [number] until
  /// the user does so
  /// 
  /// It should be able to handle any format of phone
  /// number as it ignores any character that is not 
  /// numeric. So (###) ###-####, ###-###-#### or any
  /// other format should work.
  /// 
  /// This assumes the device has the
  /// ability to launch a number. If it
  /// does not, it may throw an exception
  void call(String number) async {
    String flatNumber = number.replaceAll(RegExp(r'[^0-9]'), '');
    launch("tel://$flatNumber");
  }

  /// Opens the device's email app to send a message to
  /// [address].
  /// 
  /// This assumes the device has the
  /// ability to launch an email. If it
  /// does not, it may throw an exception
  void email(String address) async {
    launch("mailto:$address");
  }
}
