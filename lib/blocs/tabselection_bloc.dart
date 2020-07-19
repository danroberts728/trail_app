import 'package:alabama_beer_trail/blocs/bloc.dart';
import 'dart:async';

class TabSelectionBloc extends Bloc {

  static final TabSelectionBloc _singleton = TabSelectionBloc._internal();

  factory TabSelectionBloc() {
    return _singleton;
  }

  TabSelectionBloc._internal();

  int currentSelectedTab;
  final _tabSelectionController = StreamController<int>.broadcast();

  Stream<int> get tabSelectionStream =>
      _tabSelectionController.stream;

  void updateTabSelection(int tabIndex) {
    this.currentSelectedTab = tabIndex;
    _tabSelectionController.add(currentSelectedTab);
  }

  @override
  void dispose() {
    _tabSelectionController.close();
  }

}