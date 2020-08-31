import 'dart:async';

import 'package:alabama_beer_trail/blocs/bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/user_data.dart';
import 'package:intl/intl.dart';

class EditProfileScreenBloc extends Bloc {
  final _db = TrailDatabase();
  StreamSubscription _userDataSubscription;

  UserData userData;

  final _controller = StreamController<UserData>();
  Stream<UserData> get stream => _controller.stream;

  EditProfileScreenBloc() {
    userData = _db.userData;
    _userDataSubscription = _db.userDataStream.listen(_onUserDataUpdate);
  }

  void _onUserDataUpdate(UserData event) {
    userData = event;
    _controller.sink.add(userData);
  }

  void updateDisplayName(String value) {
    _db.updateUserData({'displayName': value});
  }

  void updateLocation(String value) {
    _db.updateUserData({'location': value});
  }

  void updateDob(String value) {
    if (value == null || value.isEmpty) {
      return;
    }
    try {
      _db.updateUserData({'birthdate': DateFormat("MMM d y").parse(value)});
    } catch (err) {
      print(err);
    }
  }

  void updateAboutYou(String value) {
    _db.updateUserData({'aboutYou': value});
  }

  @override
  void dispose() {
    _userDataSubscription.cancel();
    _controller.close();
  }
}
