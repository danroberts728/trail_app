import 'dart:async';

class TabSelectionService {

  static final TabSelectionService _singleton = TabSelectionService._internal();

  factory TabSelectionService() {
    return _singleton;
  }

  TabSelectionService._internal();

  int currentSelectedTab;
  bool lastTapSame;
  final _tabSelectionController = StreamController<int>.broadcast();

  Stream<int> get tabSelectionStream =>
      _tabSelectionController.stream;

  void updateTabSelection(int tabIndex) {
    if(this.currentSelectedTab == tabIndex) {
      lastTapSame = true;
    } else {
      lastTapSame = false;
    }
    this.currentSelectedTab = tabIndex;
    _tabSelectionController.add(currentSelectedTab);
  }

  void dispose() {
    _tabSelectionController.close();
  }

}