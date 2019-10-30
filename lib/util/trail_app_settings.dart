import 'package:alabama_beer_trail/data/trail_place_category.dart';
import 'package:flutter/material.dart';

class TrailAppSettings {

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

	static final Color themePrimarySwatch = Colors.brown;
  static Color get navBarBackgroundColor => first;
	static final Color navBarSelectedItemColor = Colors.white70;
	static final Color navBarUnselectedItemColor = Colors.white54;

  // Icons
	static final IconData navBarTrailIcon = Icons.location_on;
	static final IconData navBarEventsIcon = Icons.calendar_today;
	static final IconData navBarNewsIcon = Icons.rss_feed;
	static final IconData navBarProfileIcon = Icons.person;

  // Other Options
	static final bool navBarShowSelectedLabels = true;
	static final bool navBarShowUnselectedLabels = false;
	static final String newsScreenRssFeedUrl = 'https://freethehops.org/category/announcements/feed/';
	static final String defaultThumbnailUrl = 'https://freethehops.org/wp-content/uploads/sites/7/2019/05/FTH-Pocket-Logo-Teal-Front-cropped-150x150.jpeg';
	static final int locationUpdatesIntervalMs = 5000;
	static final double locationDisplacementFilterM = 10.0;
	static final double minDistanceToCheckin = 0.15;
	static final List<TrailPlaceCategory> filterStrings = <TrailPlaceCategory> [
    TrailPlaceCategory("Brewery", "Breweries"),
    TrailPlaceCategory("Distillery", "Distilleries"),
    TrailPlaceCategory("Tasting Room", "Tasting Rooms"),
    TrailPlaceCategory("Restaurant", "Restaurants"),
    TrailPlaceCategory("Open Bar", "Open Bars"),
  ];
	static final String defaultBannerImageAssetLocation = 'assets/images/fthglasses.jpg';
	static final String defaultDisplayName = "";
	static final String defaultProfilePhotoAssetLocation = 'assets/images/defaultprofilephoto.png';
}