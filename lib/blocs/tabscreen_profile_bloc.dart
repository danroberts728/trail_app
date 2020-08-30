import 'dart:async';

import 'bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/user_data.dart';

class TabscreenProfileBloc extends Bloc {
  final TrailDatabase _db = TrailDatabase();  

  StreamSubscription _userDataSubscription;

  UserData userData = UserData();

  final _userDataController = StreamController<UserData>();
  Stream<UserData> get userDataStream => _userDataController.stream; 

  TabscreenProfileBloc() {
    userData = _db.userData;
    _userDataSubscription = _db.userDataStream.listen(_onUserDataUpdate);
  }
  void _onUserDataUpdate(UserData event) {
    userData = event;
    _userDataController.sink.add(userData);
  }

  @override
  void dispose() {
    _userDataSubscription.cancel();
    _userDataController.close();
  }
}
