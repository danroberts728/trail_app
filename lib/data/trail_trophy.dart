import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TrailTrophy {
  final String id;
  final String image;
  final List<String> requiredPlaces;
  final String name;
  final String description;

  TrailTrophy(
      {@required this.id,
      @required this.image,
      @required this.requiredPlaces,
      this.name,
      this.description});

  static TrailTrophy createFromFirebase(DocumentSnapshot d) {
    try {
      return TrailTrophy(
          id: d.documentID,
          image: d['image'],
          requiredPlaces: d['req_places'],
          name: d['name'],
          description: d['description']);
    } catch (e) {
      throw e;
    }
  }
}
