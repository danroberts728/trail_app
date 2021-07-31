// Copyright (c) 2021, Fermented Software.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trail_database/model/trail_region.dart';

/// Logical representation of a region
class TrailRegion {
  TrailRegionModel _model;

  String get id => _model.id;
  String get name => _model.name;
  List<String> get places => _model.places;
  bool get published => _model.published;
  int get sortOrder => _model.sortOrder;

  TrailRegion({TrailRegionModel model}) : assert(model != null) {
    _model = model;
  }

  static TrailRegion create({
    String id,
    String name,
    List<String> places,
    bool published,
    int sortOrder,
  }) {
    return TrailRegion(
      model: TrailRegionModel(
        id: id,
        name: name,
        places: places,
        published: published,
        sortOrder: sortOrder,
      ),
    );
  }

  static TrailRegion fromFirebase(DocumentSnapshot snapshot) {
    try {
      var d = snapshot.data() as Map<String, dynamic>;
      var trailRegionModel = TrailRegionModel(
        id: snapshot.id,
        name: d['name'],
        places:
            d['places'] == null ? <String>[] : List<String>.from(d['places']),
        published: d['published'] ?? false,
        sortOrder: d['sort_order'] ?? 100,
      );
      return TrailRegion(model: trailRegionModel);
    } catch (e) {
      throw e;
    }
  }
}
