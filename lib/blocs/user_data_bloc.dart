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
    var fs = FirebaseFirestore.instance;
    fs
        .collection('user_data')
        .doc(AppAuth().user.uid)
        .get()
        .then((snapshot) {
      if (!snapshot.exists) {
        fs
            .collection('user_data')
            .doc(AppAuth().user.uid)
            .set(UserData.createBlank().toMap())
            .then((value) {
          fs
              .doc('user_data/${AppAuth().user.uid}')
              .snapshots()
              .listen(_onDataUpdate);
        });
      } else {
        fs
            .doc('user_data/${AppAuth().user.uid}')
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
    FirebaseFirestore.instance
        .collection('user_data')
        .doc(AppAuth().user.uid)
        .update({'favorites': favorites});
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
    FirebaseFirestore.instance
        .doc('user_data/${AppAuth().user.uid}')
        .update({'bannerImageUrl': url});
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
    FirebaseFirestore.instance
        .doc('user_data/${AppAuth().user.uid}')
        .update({'profilePhotoUrl': url});
  }

  Future<void> updateDisplayName(String value) async {
    FirebaseFirestore.instance
        .doc('user_data/${AppAuth().user.uid}')
        .update({'displayName': value});
  }

  Future<void> updateLocation(String value) async {
    FirebaseFirestore.instance
        .doc('user_data/${AppAuth().user.uid}')
        .update({'location': value});
  }

  Future<void> updateDob(String value) async {
    FirebaseFirestore.instance
        .doc('user_data/${AppAuth().user.uid}')
        .update({'birthdate': DateFormat("MMM d y").parse(value)});
  }

  Future<void> updateAboutYou(String value) async {
    FirebaseFirestore.instance
        .doc('user_data/${AppAuth().user.uid}')
        .update({'aboutYou': value});
  }

  void saveFcmToken(String token) {
    FirebaseFirestore.instance
      .collection('user_data')
      .doc(AppAuth().user.uid)
      .update({'fcm_token': token});
  }

  @override
  void dispose() {
    _userDataController.close();
  }
}
