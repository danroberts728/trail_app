// Copyright (c) 2021, Fermented Software.

/// Database representation of user data
class UserDataModel {
  final String bannerImageUrl;
  final String aboutYou;
  final DateTime birthDay;
  final String displayName;
  final List<String> favorites;
  final Map<String,DateTime> trophies;
  final String location;
  final String profilePhotoUrl;
  final String fcmToken;

  UserDataModel(
      {this.bannerImageUrl,
      this.aboutYou,
      this.birthDay,
      this.displayName,
      this.favorites,
      this.trophies,
      this.location,
      this.profilePhotoUrl,
      this.fcmToken});
}