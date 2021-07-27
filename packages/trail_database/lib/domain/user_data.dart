// Copyright (c) 2021, Fermented Software.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trail_database/model/user_data.dart';

/// Logical representation of user data
class UserData extends UserDataModel {
  UserData({
    String aboutYou,
    String bannerImageUrl,
    DateTime birthDay,
    String displayName,
    List<String> favorites,
    String location,
    String profilePhotoUrl,
    Map<String, DateTime> trophies,
    String fcmToken,
  }) : super(
          aboutYou: aboutYou,
          bannerImageUrl: bannerImageUrl,
          birthDay: birthDay,
          displayName: displayName,
          favorites: favorites,
          location: location,
          profilePhotoUrl: profilePhotoUrl,
          trophies: trophies,
          fcmToken: fcmToken,
        );

  static UserData createBlank() {
    return UserData(
        aboutYou: "",
        bannerImageUrl: "",
        birthDay: null,
        displayName: "",
        favorites: <String>[],
        location: "",
        profilePhotoUrl: "",
        trophies: Map<String, DateTime>(),
        fcmToken: "");
  }

  Map<String, dynamic> toMap() {
    return Map<String, dynamic>.from({
      'aboutYou': aboutYou,
      'bannerImageUrl': bannerImageUrl,
      'birthDay': birthDay,
      'displayName': displayName,
      'favorites': favorites,
      'location': location,
      'profilePhotoUrl': profilePhotoUrl,
      'trophies': trophies,
      'fcmToken': fcmToken
    });
  }

  static UserData fromFirebase(DocumentSnapshot snapshot) {
    try {
      var d = snapshot.data() as Map<String, dynamic>;
      return UserData(
          aboutYou: d['aboutYou'],
          bannerImageUrl: d['bannerImageUrl'],
          birthDay: d['birthdate'] != null ? d['birthdate'].toDate() : null,
          displayName: d['displayName'],
          favorites: d['favorites'] != null
              ? List<String>.from(d['favorites'])
              : <String>[],
          trophies: d['trophies'] != null
              ? Map<String, Timestamp>.from(d['trophies'])
                  .map((key, value) => MapEntry(key, value.toDate()))
              : Map<String, DateTime>(),
          location: d['location'],
          profilePhotoUrl: d['profilePhotoUrl']);
    } catch (e) {
      print("Error buliding user data from firebase: $e");
      return UserData(
          aboutYou: null,
          bannerImageUrl: null,
          birthDay: DateTime.now(),
          displayName: null,
          favorites: <String>[],
          trophies: Map<String, DateTime>(),
          location: null,
          profilePhotoUrl: null);
    }
  }
}
