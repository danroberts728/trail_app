import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String bannerImageUrl;
  final String aboutYou;
  final DateTime birthDay;
  final String displayName;
  final List<String> favorites;
  final String location;
  final String profilePhotoUrl;

  UserData(
      {this.bannerImageUrl,
      this.aboutYou,
      this.birthDay,
      this.displayName,
      this.favorites,
      this.location,
      this.profilePhotoUrl});

  static UserData fromFirebase(DocumentSnapshot d) {
    try {
      return UserData(
          aboutYou: d['aboutYou'],
          bannerImageUrl: d['bannerImageUrl'],
          birthDay: d['birthdate'].toDate(),
          displayName: d['displayName'],
          favorites: List<String>.from(d['favorites']),
          location: d['location'],
          profilePhotoUrl: d['profilePhotoUrl']);
    } catch (e) {
      print("Error buliding user data from firebase: $e");
      return UserData(
        aboutYou: null,
        bannerImageUrl: null,
        birthDay: DateTime.now(),
        displayName: null,
        favorites: List<String>(),
        location: null,
        profilePhotoUrl: null);

    }
  }
}
