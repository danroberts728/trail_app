import 'dart:async';

import 'package:alabama_beer_trail/blocs/bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/user_data.dart';

class TrophyDetailScreenBloc extends Bloc {
  final _db = TrailDatabase();
  StreamSubscription _userDataSubscription;

  Map<String, DateTime> earnedTrophies;

  final _controller = StreamController<Map<String, DateTime>>();
  Stream<Map<String, DateTime>> get stream => _controller.stream;

  TrophyDetailScreenBloc() {
    earnedTrophies = _db.userData.trophies;
    _userDataSubscription = _db.userDataStream.listen(_onUserDataUpdate);
  }

  void _onUserDataUpdate(UserData event) {
    earnedTrophies = event.trophies;
    _controller.sink.add(earnedTrophies);
  }

  @override
  void dispose() {
    _userDataSubscription.cancel();
    _controller.close();
  }

}