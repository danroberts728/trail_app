import 'package:alabama_beer_trail/blocs/bloc.dart';
import 'dart:async';

class TabSelectionBloc extends Bloc {

  static final TabSelectionBloc _singleton = TabSelectionBloc._internal();

  factory TabSelectionBloc() {
    return _singleton;
  }

  TabSelectionBloc._internal();

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

  @override
  void dispose() {
    _tabSelectionController.close();
  }

}