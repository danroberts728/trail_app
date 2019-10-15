import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:path/path.dart';
import '../util/appauth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'bloc.dart';

class UserDataBloc implements Bloc {
  UserDataBloc() {
    Firestore.instance.document('user_data/${AppAuth().user.uid}').snapshots().listen(_onDataUpdate);
    this.userData['favorites'] = List<String>();
  }

  var userData = Map<String, dynamic>();
  final _userDataController = StreamController<Map<String, dynamic>>();
  Stream<Map<String, dynamic>> get userDataStream  => _userDataController.stream;  

  void _onDataUpdate(DocumentSnapshot documentSnapshot) {
    var newData = documentSnapshot.data;
    this.userData = newData;
    this._userDataController.sink.add(this.userData);
  }

  void toggleFavorite(String placeId) {
    List<String> favorites = List<String>.from(this.userData['favorites']);
    if(favorites.contains(placeId)) {
      favorites.remove(placeId);
    } else {
      favorites.add(placeId);
    }
    Firestore.instance.collection('user_data').document(AppAuth().user.uid).updateData(
      {'favorites': favorites});
  }

  Future<void> updateBannerImage(File file) async {
    String ext = extension(file.path);
    String storageFileName = Random().nextInt(100000).toString() + '.$ext';
    StorageReference storageRef = FirebaseStorage.instance.ref().child('userData/' + storageFileName);
    StorageUploadTask uploadTask = storageRef.putFile(
      file,
      StorageMetadata(
        contentType: 'type/' + ext,
      ),
    );
    StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    String url = (await downloadUrl.ref.getDownloadURL());
    Firestore.instance.document('user_data/${AppAuth().user.uid}').updateData(
      {'bannerImageUrl': url}
    );
  }

  Future<void> updateProfileImage(File file) async {
    String ext = extension(file.path);
    String storageFileName = Random().nextInt(100000).toString() + '.$ext';
    StorageReference storageRef = FirebaseStorage.instance.ref().child('userData/' + storageFileName);
    StorageUploadTask uploadTask = storageRef.putFile(
      file,
      StorageMetadata(
        contentType: 'type/' + ext,
      ),
    );
    StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    String url = (await downloadUrl.ref.getDownloadURL());
    Firestore.instance.document('user_data/${AppAuth().user.uid}').updateData(
      {'profilePhotoUrl': url}
    );
  }

  @override
  void dispose() {
    _userDataController.close();
  }  
}