// Copyright (c) 2020, Fermented Software.
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import 'package:beer_trail_app/blocs/bloc.dart';
import 'package:beer_trail_database/trail_database.dart';
import 'package:beer_trail_database/domain/user_data.dart';

/// The BLoC for ProfileUserPhoto objects
class ProfileUserPhotoBloc extends Bloc {
  /// A reference to the central database
  TrailDatabase _db;

  /// A subscription to the user's data
  StreamSubscription _userDataSubscription;

  /// The current user's profile image
  String profileImageUrl;

  /// Controller for this BLoC's stream
  final _controller = StreamController<String>();

  /// The stream for this BLoC's profile image URL
  Stream<String> get stream => _controller.stream;

  /// Default constructor
  ProfileUserPhotoBloc(TrailDatabase db) : assert(db != null) {
    _db = db;
    profileImageUrl = _db.userData.profilePhotoUrl;
    _userDataSubscription = _db.userDataStream.listen(_onUserDataUpdate);
  }

  /// Callback when user's data is updated
  void _onUserDataUpdate(UserData event) {
    var newProfileImage = event.profilePhotoUrl;
    if(newProfileImage != profileImageUrl) {
      profileImageUrl = newProfileImage;
      _controller.sink.add(profileImageUrl);
    }
  }

  /// Updates the user's profile image with [file]. Uploads
  /// the [file] to storage and updates the reference in the
  /// user's data.
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
    _db.updateUserData({'profilePhotoUrl': url});
  }

  /// Dipose object
  @override
  void dispose() {
    _userDataSubscription.cancel();
    _controller.close();
  }

}