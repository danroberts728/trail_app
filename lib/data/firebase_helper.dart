import 'dart:ui';

import 'package:beer_trail_app/model/trail_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:beer_trail_app/model/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:beer_trail_app/model/beer.dart';
import 'package:beer_trail_app/model/on_tap_beer.dart';

class FirebaseHelper {
  static AppUser appUserfromFirebaseUser(User user) {
    if (user == null) {
      return null;
    } else {
      return AppUser(
          email: user.email,
          uid: user.uid,
          isAnonymous: user.isAnonymous,
          createdDate:
              DateFormat("MMM d, y").format(user.metadata.creationTime));
    }
  }

  /// Creates a beer from a query document snapshot from firebase
  ///
  /// Returns null if the beer does not find a name or untappd ID
  static Beer createBeerFromFirebase(QueryDocumentSnapshot snapshot) {
    try {
      var d = snapshot.data();
      var beer = Beer(
        abv: d['beer_abv'] + 0.0 ?? 0.0,
        description: d['beer_description'] ?? "",
        ibu: d['beer_ibu'] ?? 0,
        labelUrl: d['beer_label'] ?? "",
        name: d['beer_name'] ?? "",
        style: d['beer_style'] ?? "",
        isInProduction: d['is_in_production'] == 1,
        untappdId: d['untappdId'] ?? 0,
        untappdRatingCount: d['untappd_rating_count'] ?? 0,
        untappdRatingScore: d['untappd_rating_score'] + .0 ?? 0,
      );
      if (beer.name == "" || beer.untappdId == 0) {
        return null;
      } else {
        return beer;
      }
    } catch (err) {
      return null;
    }
  }

  /// Creates an OnTapBeer from a query document snapshot from firebase
  ///
  /// Returns null if the beer does not find a name or untappd ID
  static OnTapBeer createOnTapBeerFromFirebase(QueryDocumentSnapshot snapshot) {
    try {
      var d = snapshot.data();
      var beer = OnTapBeer(
        abv: d['abv'] == null ? "" : d['abv'],
        beerId: d['beer_id'] == null ? 0 : d['beer_id'],
        description: d['description'] == null ? "" : d['description'],
        prices: d['prices'] == null
            ? <OnTapPrice>[]
            : List<OnTapPrice>.from(d['prices'].map((item) {
                return OnTapPrice(
                    name: item['serving_size_name'],
                    price: double.tryParse(item['price']),
                    volumeOz: double.tryParse(item['serving_size_volume_oz']));
              })),
        ibu: d['ibu'] == null ? 0 : d['ibu'],
        logoUrl: d['logo_url'] == null ? "" : d['logo_url'],
        manufacturer:
            d['manufacturer_name'] == null ? "" : d['manufacturer_name'],
        name: d['name'] == null ? "" : d['name'],
        style: d['style'] == null ? "" : d['style'],
        untappdUrl: d['untappd_url'] == null ? "" : d['untappd_url'],
      );
      if (beer.name == "") {
        return null;
      } else {
        return beer;
      }
    } catch (err) {
      return null;
    }
  }

  /// Build a TrailEvent from a [snapshot]
  static TrailEvent createTrailEventFromFirebaseDoc(DocumentSnapshot snapshot) {
    var data = snapshot.data();
    var id = snapshot.id;
    return _buildFromSnapshot(id, data);
  }

  /// Build a TrailEvent from a [snapshot]
  static TrailEvent createTrailEventFromFirebaseQueryDoc(
      QueryDocumentSnapshot snapshot) {
    var data = snapshot.data();
    var id = snapshot.id;
    return _buildFromSnapshot(id, data);
  }

  /// Build a TrailEvent from a snapshot's [data] with [id]
  static TrailEvent _buildFromSnapshot(String id, Map<String, dynamic> data) {
    try {
      var trailEvent = TrailEvent(
        id: id,
        name: data['name'] ?? '<Unnamed>',
        details: data['details'] ?? '',
        color: data['color'] != null ? _fromHex(data['color']) : Colors.black,
        featured: data['featured'] != null ? data['featured'] == 'yes' : false,
        imageUrl: data['image_url'] != null ? data['image_url'] : null,
        learnMoreLink:
            data['learnmore_link'] != null ? data['learnmore_link'] : '',
        status: data['status'] != null ? data['status'] : '',
        locationTaxonomy:
            data['location_tax'] != null ? data['location_tax'] : 0,
        locationName:
            data['location_name'] != null ? data['location_name'] : '',
        locationAddress:
            data['location_address'] != null ? data['location_address'] : '',
        locationCity:
            data['location_city'] != null ? data['location_city'] : '',
        locationState:
            data['location_state'] != null ? data['location_state'] : '',
        locationLat: data['location_lat'] != null
            ? double.tryParse(data['location_lat'])
            : null,
        locationLon: data['location_lon'] != null
            ? double.tryParse(data['location_lon'])
            : null,
        start: data['start_timestamp_seconds'] != null
            ? Timestamp(data['start_timestamp_seconds'], 0)
                .toDate()
                .subtract(DateTime.now().timeZoneOffset)
            : DateTime(2000),
        end: data['end_timestamp_seconds'] != null
            ? Timestamp(data['end_timestamp_seconds'], 0)
                .toDate()
                .subtract(DateTime.now().timeZoneOffset)
            : null,
        hideEndTime: data['hide_endtime'] != null
            ? data['hide_endtime'] == 'yes'
            : false,
        allDayEvent: data['all_day_event'] != null
            ? data['all_day_event'] == "yes"
            : false,
      );
      // Return null if lat/lon or start time is not set correctly
      if (trailEvent.locationLat == null ||
          trailEvent.locationLon == null ||
          trailEvent.start == DateTime(2000)) {
        return null;
      }
      return trailEvent;
    } catch (e) {
      return null;
    }
  }

  /// Return an ARGB color from a RGB hex string
  static Color _fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
