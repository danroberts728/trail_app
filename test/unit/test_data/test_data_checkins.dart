// Copyright (c) 2020, Fermented Software.
import 'package:beer_trail_app/model/check_in.dart';

/// To use:
/// import '../test_data/test_data_checkins.dart' as testCheckins;
/// List<CheckIn> testCheckinData = testCheckins.TestDataCheckIns.checkIns;
class TestDataCheckIns {
  static List<CheckIn> checkIns = [
    CheckIn('avondale', DateTime(2020, 10, 16)),
    CheckIn('cahaba', DateTime(2020, 8, 16)),
    CheckIn('avondale', DateTime(2020, 8, 17)),
    CheckIn('true-story', DateTime(2020, 8, 17)),
    CheckIn('sta', DateTime(2020, 10, 2)),
    CheckIn('yellowhammer', DateTime(2020, 10, 3)),
    CheckIn('cahaba', DateTime(2020, 12, 1)),
  ];
}
