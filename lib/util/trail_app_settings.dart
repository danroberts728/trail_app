import 'package:alabama_beer_trail/data/trail_place_category.dart';
import 'package:flutter/material.dart';

class TrailAppSettings {
  // Primary Colors
  static final Color mainHeadingColor = Color(0xFF93654E);
  static final Color subHeadingColor = Color(0xFF4E7C93);
  static final Color actionLinksColor = Color(0xFF5A934E);
  static final Color attentionColor = Color(0xFF874E93);
  static final Color errorColor = Colors.red;

  // Assets
  static final String signInBackgroundAsset = "assets/images/signin_bkg.jpg";

  // Theme colors
  static final MaterialColor themePrimarySwatch =
      MaterialColor(mainHeadingColor.value, {
    50: mainHeadingColor.withOpacity(0.1),
    100: mainHeadingColor.withOpacity(0.2),
    200: mainHeadingColor.withOpacity(0.3),
    300: mainHeadingColor.withOpacity(0.4),
    400: mainHeadingColor.withOpacity(0.5),
    500: mainHeadingColor.withOpacity(0.6),
    600: mainHeadingColor.withOpacity(0.7),
    700: mainHeadingColor.withOpacity(0.8),
    800: mainHeadingColor.withOpacity(0.9),
    900: mainHeadingColor.withOpacity(1),
  });
  static final Color navBarBackgroundColor = mainHeadingColor;
  static final Color navBarSelectedItemColor = Colors.white70;

  // Sign In Screen
  static final String signInAppBarTitle = "Sign In";
  static final Color signInSignInButtonColor = actionLinksColor;
  static final Color signInForgotPwdColor = actionLinksColor;
  static final String signInButtonText = "Sign In";

  // Strings
  static final String appName = "Alabama Beer Trail";
  static final String navBarTrailTabTitle = "Alabama Beer Trail";
  static final String navBarTrailLabel = "Trail";
  static final String navBarEventsTabTitle = "Alabama Beer Events";
  static final String navBarEventsLabel = "Events";
  static final String navBarNewsTabTitle = "Alabama Beer News";
  static final String navBarNewsLabel = "News";
  static final String navBarProfileLabel = "Profile";
  static final String navBarProfileTabTitle = "Your Profile";

  // Colors
  static final Color first = Color(0xFF93654E);
  static final Color second = Color(0xFF5A934E);
  static final Color third = Color(0xFF4E7C93);
  static final Color fourth = Color(0xFF874E93);

  // Icons
  static final IconData navBarTrailIcon = Icons.location_on;
  static final IconData navBarEventsIcon = Icons.calendar_today;
  static final IconData navBarNewsIcon = Icons.rss_feed;
  static final IconData navBarProfileIcon = Icons.person;

  // Events Tab Options
  static final List<int> eventFilterDistances = [5, 25, 50, 100];

  // Other Options
  static final bool navBarShowSelectedLabels = true;
  static final bool navBarShowUnselectedLabels = false;
  static final String newsScreenRssFeedUrl =
      'https://freethehops.org/category/app-publish/feed/';
  static final String defaultNewsThumbnailAsset =
      'assets/images/newsfeed_empty_image.jpg';
  static final int locationUpdatesIntervalMs = 30000;
  static final double locationUpdatesDisplacementThreshold = 10;
  static final double minDistanceToCheckin = 0.10;
  static final List<TrailPlaceCategory> filterStrings = <TrailPlaceCategory>[
    TrailPlaceCategory("Brewery", "Breweries"),
    TrailPlaceCategory("Distillery", "Distilleries"),
    TrailPlaceCategory("Tasting Room", "Tasting Rooms"),
    TrailPlaceCategory("Restaurant", "Restaurants"),
    TrailPlaceCategory("Open Bar", "Open Bars"),
  ];
  static final String defaultBannerImageAssetLocation =
      'assets/images/fthglasses.jpg';
  static final String defaultDisplayName = " ";
  static final String defaultProfilePhotoAssetLocation =
      'assets/images/defaultprofilephoto.png';

  static final String privacyPolicyUrl = "https://freethehops.org/apps/alabama-beer-trail-privacy-policy/";
  static final String submitFeedbackUrl = "https://freethehops.org/apps/submit-feedback/";
}
