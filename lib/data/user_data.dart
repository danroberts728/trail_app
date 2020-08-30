import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String bannerImageUrl;
  final String aboutYou;
  final DateTime birthDay;
  final String displayName;
  final List<String> favorites;
  final Map<String,DateTime> trophies;
  final String location;
  final String profilePhotoUrl;
  final String fcmToken;

  UserData(
      {this.bannerImageUrl,
      this.aboutYou,
      this.birthDay,
      this.displayName,
      this.favorites,
      this.trophies,
      this.location,
      this.profilePhotoUrl,
      this.fcmToken});

  static UserData createBlank() {
    return UserData(
      aboutYou: "",
      bannerImageUrl: "",
      birthDay: null,
      displayName: "",
      favorites: List<String>(),
      location: "",
      profilePhotoUrl: "",
      trophies: Map<String, DateTime>(),
      fcmToken: ""
    );
  }

  Map<String,dynamic> toMap() {
    return Map<String, dynamic>.from(
      {
        'aboutYou': aboutYou,
        'bannerImageUrl': bannerImageUrl,
        'birthDay': birthDay,
        'displayName': displayName,
        'favorites': favorites,
        'location': location,
        'profilePhotoUrl': profilePhotoUrl,
        'trophies': trophies,
        'fcmToken': fcmToken
      }
    );
  }

  static UserData fromFirebase(DocumentSnapshot snapshot) {
    try {
      var d = snapshot.data();
      return UserData(        
          aboutYou: d['aboutYou'],
          bannerImageUrl: d['bannerImageUrl'],
          birthDay: d['birthdate'] != null
            ? d['birthdate'].toDate()
            : null,
          displayName: d['displayName'],
          favorites: d['favorites'] != null
            ? List<String>.from(d['favorites'])
            : List<String>(),
          trophies: d['trophies'] != null
            ? Map<String,Timestamp>.from(d['trophies']).map((key, value) => MapEntry(key, value.toDate()))
            : Map<String,DateTime>(),
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
        trophies: Map<String,DateTime>(),
        location: null,
        profilePhotoUrl: null);

    }
  }
}
