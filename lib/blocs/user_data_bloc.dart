import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:alabama_beer_trail/data/user_data.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import '../blocs/appauth_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'bloc.dart';

class UserDataBloc implements Bloc {
  static final UserDataBloc _singleton = UserDataBloc._internal();

  factory UserDataBloc() {
    return _singleton;
  }

  UserDataBloc._internal() {
    var fs = Firestore.instance;
    fs
        .collection('user_data')
        .document(AppAuth().user.uid)
        .get()
        .then((snapshot) {
      if (!snapshot.exists) {
        fs
            .collection('user_data')
            .document(AppAuth().user.uid)
            .setData(UserData.createBlank().toMap())
            .then((value) {
          fs
              .document('user_data/${AppAuth().user.uid}')
              .snapshots()
              .listen(_onDataUpdate);
        });
      } else {
        fs
            .document('user_data/${AppAuth().user.uid}')
            .snapshots()
            .listen(_onDataUpdate);
      }
    });
  }

  UserData userData = UserData(
    favorites: List<String>(),
  );
  final _userDataController = StreamController<UserData>.broadcast();
  Stream<UserData> get userDataStream =>
      _userDataController.stream.asBroadcastStream();

  void _onDataUpdate(DocumentSnapshot documentSnapshot) {
    var newData = documentSnapshot;
    if (!newData.exists) {
      _buildNewUserData();
    }
    try {
      this.userData = UserData.fromFirebase(newData);
      this._userDataController.sink.add(this.userData);
    } catch (e) {
      print(e);
    }
  }

  void toggleFavorite(String placeId) {
    List<String> favorites = List<String>.from(this.userData.favorites);
    if (favorites.contains(placeId)) {
      favorites.remove(placeId);
    } else {
      favorites.add(placeId);
    }
    Firestore.instance
        .collection('user_data')
        .document(AppAuth().user.uid)
        .updateData({'favorites': favorites});
  }

  Future<String> updateBannerImage(File file) async {
    String ext = extension(file.path);
    String storageFileName = Random().nextInt(100000).toString() + '.$ext';
    StorageReference storageRef =
        FirebaseStorage.instance.ref().child('userData/' + storageFileName);
    StorageUploadTask uploadTask = storageRef.putFile(
      file,
      StorageMetadata(
        contentType: 'type/' + ext,
      ),
    );
    StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    String url = (await downloadUrl.ref.getDownloadURL());
    Firestore.instance
        .document('user_data/${AppAuth().user.uid}')
        .updateData({'bannerImageUrl': url});
    return Future.value(url);
  }

  Future<void> updateProfileImage(File file) async {
    String ext = extension(file.path);
    String storageFileName = Random().nextInt(100000).toString() + '.$ext';
    StorageReference storageRef =
        FirebaseStorage.instance.ref().child('userData/' + storageFileName);
    StorageUploadTask uploadTask = storageRef.putFile(
      file,
      StorageMetadata(
        contentType: 'type/' + ext,
      ),
    );
    StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    String url = (await downloadUrl.ref.getDownloadURL());
    Firestore.instance
        .document('user_data/${AppAuth().user.uid}')
        .updateData({'profilePhotoUrl': url});
  }

  Future<void> updateDisplayName(String value) async {
    Firestore.instance
        .document('user_data/${AppAuth().user.uid}')
        .updateData({'displayName': value});
  }

  Future<void> updateLocation(String value) async {
    Firestore.instance
        .document('user_data/${AppAuth().user.uid}')
        .updateData({'location': value});
  }

  Future<void> updateDob(String value) async {
    Firestore.instance
        .document('user_data/${AppAuth().user.uid}')
        .updateData({'birthdate': DateFormat("MMM d y").parse(value)});
  }

  Future<void> updateAboutYou(String value) async {
    Firestore.instance
        .document('user_data/${AppAuth().user.uid}')
        .updateData({'aboutYou': value});
  }

  void _buildNewUserData() {
    Firestore.instance
        .collection('user_data')
        .document(AppAuth().user.uid)
        .setData({'favorites': List<String>()});
  }

  @override
  void dispose() {
    _userDataController.close();
  }
}
