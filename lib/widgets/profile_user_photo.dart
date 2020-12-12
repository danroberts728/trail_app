// Copyright (c) 2020, Fermented Software.
import 'dart:io';

import 'package:alabama_beer_trail/blocs/profile_user_photo_bloc.dart';
import 'package:alabama_beer_trail/data/trail_database.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/// The user's profile photo (circular)
class ProfileUserPhoto extends StatefulWidget {
  final String imageUrl;
  final ImageProvider backupImage;
  final bool canEdit;
  final Widget placeholder;
  final double height;
  final double width;

  ProfileUserPhoto(this.imageUrl,
      {@required this.backupImage,
      @required this.canEdit,
      @required this.placeholder,
      this.height = 100.0,
      this.width = 100.0});

  @override
  State<StatefulWidget> createState() => _ProfileUserPhoto(imageUrl);
}

class _ProfileUserPhoto extends State<ProfileUserPhoto> {
  String imageUrl;

  var _bloc = ProfileUserPhotoBloc(TrailDatabase());
  final double _maxHeight = 400.0;
  final int _imageQuality = 75;

  _ProfileUserPhoto(
      this.imageUrl);

  @override
  void initState() {
    super.initState();
    _bloc.stream.listen((newData) {
      this.imageUrl = newData;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget imageProvider = imageUrl != null && imageUrl.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: this.imageUrl,
            imageBuilder: (context, imageProvider) => Container(
                  width: widget.width,
                  height: widget.height,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3.0),
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
            placeholder: (context, url) => Container(
                width: widget.width,
                height: widget.height,
                child: Center(child: widget.placeholder)),
            errorWidget: (context, url, error) => Icon(Icons.error))
        : Container(
            width: widget.width,
                height: widget.height,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3.0),
                image: DecorationImage(
                    image: widget.backupImage, fit: BoxFit.cover)));

    var stackedWidgets = <Widget>[imageProvider];
    if (widget.canEdit) {
      stackedWidgets.add(editButton());
    }

    return Stack(
      children: stackedWidgets,
    );
  }

  void saveImage(PickedFile file) {
    Navigator.pop(context);
    ImageCropper.cropImage(
      sourcePath: file.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      aspectRatioPresets: [CropAspectRatioPreset.square],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: "Crop Profile Image",
          toolbarColor: TrailAppSettings.themePrimarySwatch,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true),
      iosUiSettings:
          IOSUiSettings(aspectRatioLockEnabled: true, minimumAspectRatio: 1),
    ).then((File croppedFile) {
      var image = decodeImage((croppedFile).readAsBytesSync());
      var scaledImage = copyResize(image, width: 800, height: 800);
      String scaledImageFilename = croppedFile.path +
          DateTime.now().millisecondsSinceEpoch.toString() +
          '.jpg';
      File(scaledImageFilename)
        ..writeAsBytesSync(encodeJpg(scaledImage, quality: this._imageQuality));
      _bloc.updateProfileImage(File(scaledImageFilename));
    });
  }

  Future<dynamic> showBottomModalSelector() {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        elevation: 8.0,
        builder: (context) {
          return Container(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 16.0),
                  Text("Where would you like to take the photo from?"),
                  SizedBox(height: 16.0),
                  MaterialButton(
                    minWidth: double.infinity,
                    child: Text("Camera"),
                    onPressed: () {
                      var picker = ImagePicker();
                      picker
                          .getImage(
                        source: ImageSource.camera,
                        maxHeight: this._maxHeight,
                      )
                          .then((file) {
                        this.saveImage(file);
                      });
                    },
                  ),
                  MaterialButton(
                    minWidth: double.infinity,
                    child: Text("Photo Gallery"),
                    onPressed: () {
                      var picker = ImagePicker();
                      picker
                          .getImage(
                        source: ImageSource.gallery,
                        maxHeight: this._maxHeight,
                      )
                          .then((file) {
                        this.saveImage(file);
                      });
                    },
                  ),
                  MaterialButton(
                    minWidth: double.infinity,
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ));
        });
  }

  Widget editButton() {
    return Container(
      height: 100.0,
      width: 100.0,
      child: Center(
        child: FloatingActionButton(
          heroTag: 'ProfilePhotoEditButton',
          mini: true,
          elevation: 16.0,
          backgroundColor: TrailAppSettings.second.withAlpha(125),
          child: Icon(
            Icons.add_a_photo,
          ),
          onPressed: () {
            PermissionHandler()
                .checkPermissionStatus(PermissionGroup.camera)
                .then((status) {
              if (status == PermissionStatus.granted) {
                this.showBottomModalSelector();
              } else {
                PermissionHandler().requestPermissions(
                    [PermissionGroup.camera]).then((status) {
                  this.showBottomModalSelector();
                });
              }
            });
          },
        ),
      ),
    );
  }
}
