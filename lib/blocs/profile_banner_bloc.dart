// Copyright (c) 2020, Fermented Software.

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import 'package:alabama_beer_trail/blocs/bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/user_data.dart';

/// A BLoC for ProfileBanner objects
class ProfileBannerBloc extends Bloc {
  /// A reference to the central database.
  TrailDatabase _db;

  /// A subscription to the user data data stream
  StreamSubscription _userDataSubscription;

  /// The banner Image URL for the current user
  String bannerImageUrl;
  
  /// The controller for this BLoC's stream
  final _controller = StreamController<String>();

  /// The stream for the user's banner Image URL
  Stream<String> get stream => _controller.stream;

  /// Default constructor
  ProfileBannerBloc(TrailDatabase db) 
    : assert(db != null) {
    _db = db;
    bannerImageUrl = _db.userData.bannerImageUrl;
    _userDataSubscription = _db.userDataStream.listen(_onUserDataUpdate);
  }

  /// Callback when the user data gets new data
  void _onUserDataUpdate(UserData event) {
    var newBannerImage = event.bannerImageUrl;
    if (newBannerImage != bannerImageUrl) {
      bannerImageUrl = newBannerImage;
      _controller.sink.add(bannerImageUrl);
    }
  }

  /// Updates the current user's banner image URL with
  /// [file]. Uploads the file to cloud storage and sets
  /// the reference in the user's data.
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
    _db.updateUserData({'bannerImageUrl': url});
    return Future.value(url);
  }

  /// Dispose the object.
  @override
  void dispose() {
    _userDataSubscription.cancel();
    _controller.close();
  }
}
