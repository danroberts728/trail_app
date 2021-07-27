// Copyright (c) 2021, Fermented Software.
import 'package:trail_database/model/check_in.dart';

/// Logical representation of a check in
class CheckIn {
  CheckInModel _model;

  String get placeId => _model.placeId;
  DateTime get timestamp => _model.timestamp;

  /// Creates a check in from manual data
  static CheckIn create({String placeId, DateTime timestamp}) {
    return CheckIn(model: CheckInModel(placeId: placeId, timestamp: timestamp));
  }

  CheckIn({CheckInModel model}) : assert(model != null) {
    _model = model;
  }
}
