// Copyright (c) 2020, Fermented Software.
import 'package:trail_database/domain/check_in.dart';

/// To use:
/// import '../test_data/test_data_checkins.dart' as testCheckins;
/// List<CheckIn> testCheckinData = testCheckins.TestDataCheckIns.checkIns;
class TestDataCheckIns {
  static List<CheckIn> checkIns = [
    CheckIn.create(placeId: 'avondale', timestamp: DateTime(2020, 10, 16)),
    CheckIn.create(placeId: 'cahaba', timestamp: DateTime(2020, 8, 16)),
    CheckIn.create(placeId: 'avondale', timestamp: DateTime(2020, 8, 17)),
    CheckIn.create(placeId: 'true-story', timestamp: DateTime(2020, 8, 17)),
    CheckIn.create(placeId: 'sta', timestamp: DateTime(2020, 10, 2)),
    CheckIn.create(placeId: 'yellowhammer', timestamp: DateTime(2020, 10, 3)),
    CheckIn.create(placeId: 'cahaba', timestamp: DateTime(2020, 12, 1)),
  ];
}
