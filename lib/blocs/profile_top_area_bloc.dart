import 'dart:async';

import 'bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/user_data.dart';

class ProfileTopAreaBloc extends Bloc {
  final _db = TrailDatabase();
  StreamSubscription _userDataSubscription;

  UserData userData = UserData.createBlank();

  final _streamController = StreamController<UserData>();
  get stream => _streamController.stream;

  ProfileTopAreaBloc() {
    userData = _db.userData;
    _userDataSubscription = _db.userDataStream.listen(_onUserDataUpdate);
  }

  void _onUserDataUpdate(UserData event) {
    userData = event;
    _streamController.sink.add(userData);
  }

  @override
  void dispose() {
    _streamController.close();
    _userDataSubscription.cancel();
  }
}
