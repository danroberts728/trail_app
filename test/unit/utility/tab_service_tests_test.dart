// Copyright (c) 2020, Fermented Software.
import 'package:beer_trail_app/util/tabselection_service.dart';
import 'package:test/test.dart';

/// Test for the Tab Selection Service utility class
void main() {
group('Tab selection', () {
    test('Update tab', () {
      TabSelectionService _tabService = TabSelectionService();
      _tabService.updateTabSelection(2);
      expect(_tabService.currentSelectedTab, equals(2));
    });
    test('Last tab same', () {
      TabSelectionService _tabService = TabSelectionService();
      _tabService.currentSelectedTab = 3;
      _tabService.updateTabSelection(3);
      expect(_tabService.lastTapSame, equals(true));
    });
    test('Last tab different', () {
      TabSelectionService _tabService = TabSelectionService();
      _tabService.currentSelectedTab = 3;
      _tabService.updateTabSelection(1);
      expect(_tabService.lastTapSame, equals(false));
    });
  });
}
