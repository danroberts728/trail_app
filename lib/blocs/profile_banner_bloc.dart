import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import 'package:alabama_beer_trail/blocs/bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/data/user_data.dart';

class ProfileBannerBloc extends Bloc {
  final _db = TrailDatabase();
  StreamSubscription _userDataSubscription;

  String bannerImageUrl;

  final _controller = StreamController<String>();
  Stream<String> get stream => _controller.stream;

  ProfileBannerBloc() {
    bannerImageUrl = _db.userData.bannerImageUrl;
    _userDataSubscription = _db.userDataStream.listen(_onUserDataUpdate);
  }

  void _onUserDataUpdate(UserData event) {
    var newBannerImage = event.bannerImageUrl;
    if(newBannerImage != bannerImageUrl) {
      bannerImageUrl = newBannerImage;
      _controller.sink.add(bannerImageUrl);
    }
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
    _db.updateUserData({'bannerImageUrl': url});
    return Future.value(url);
  }

  @override
  void dispose() {
    _userDataSubscription.cancel();
    _controller.close();
  }

}