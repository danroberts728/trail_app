import 'dart:async';

import 'bloc.dart';

class EventFilterBloc extends Bloc { 
  static final EventFilterBloc _singleton = EventFilterBloc._internal();

  factory EventFilterBloc() {
    return _singleton;
  }

  EventFilterBloc._internal();

  double distance = 50.0;
  final _eventFilterController = StreamController<double>.broadcast();
  Stream<double> get eventFilterStream => _eventFilterController.stream;


  void updateFilter(double distance) {
    this.distance = distance;
    _eventFilterController.sink.add(distance);
  }

  @override
  void dispose() {
    _eventFilterController.close();
  }
}