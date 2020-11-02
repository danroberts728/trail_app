// Copyright (c) 2020, Fermented Software.
import 'package:alabama_beer_trail/data/user_data.dart';

class TestDataUserData {
  static UserData userData = UserData(
    aboutYou: "What's wrong with the beer we got?",
    bannerImageUrl: "https://freethehops.org/banner.jpg",
    birthDay: DateTime(1981,07,28),
    displayName: "Dan Roberts",
    favorites: ['avondale', 'cahaba', 'sta'],
    fcmToken: "epUPuvd9QcOb9Jlj-E2ePJ:APA91bHHkj5W_q457wRNzPgdBNZPMRgBahVPrAd5wupoAwTiZ67AKloIG7-ZAu8m6Kf2dxhtH_JS8JWEiKpd856b9Za9K7hzx_Q0VEyU-MTSDL1zn9ld9j3jUv2ASMjHUl2T7HLNiAAG",
    location: "Moody, AL",
    profilePhotoUrl: "https://freethehops.org/profile_photo.jpg",
    trophies: {
      'champion': DateTime(2020,10,18),
      'journey-begins': DateTime(2020,10,17),
    },
  );
}