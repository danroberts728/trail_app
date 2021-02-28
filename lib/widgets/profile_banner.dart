// Copyright (c) 2021, Fermented Software.
import 'dart:io';

import 'package:beer_trail_app/blocs/profile_banner_bloc.dart';
import 'package:trail_database/trail_database.dart';
import 'package:beer_trail_app/util/trail_app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart';

class ProfileBanner extends StatefulWidget {
  final String imageUrl;
  final ImageProvider backupImage;
  final bool canEdit;
  final Widget placeholder;

  ProfileBanner(this.imageUrl,
      {@required this.canEdit, @required this.backupImage, this.placeholder});

  @override
  State<StatefulWidget> createState() => _ProfileBanner(
      this.imageUrl, this.backupImage, this.canEdit, this.placeholder);
}

class _ProfileBanner extends State<ProfileBanner> {
  String imageUrl;
  final ImageProvider backupImage;
  final bool canEdit;
  Widget placeholder;

  final _bloc = ProfileBannerBloc(TrailDatabase());
  final int _imageQuality = 75;
  final double _maxHeight = 400.0;

  _ProfileBanner(
      this.imageUrl, this.backupImage, this.canEdit, this.placeholder);

  @override
  void initState() {
    super.initState();
    this._bloc.stream.listen((newData) {
      this.imageUrl = newData;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget imageProvider = LayoutBuilder(
      builder: (context, constraints) {
        return imageUrl != null && imageUrl.isNotEmpty
            ? CachedNetworkImage(
                color: Colors.grey,
                imageUrl: this.imageUrl,
                imageBuilder: (context, imageProvider) => Container(
                  width: constraints.maxWidth,
                  height: constraints.maxWidth * (9 / 16),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => Icon(Icons.error),
              )
            : Container(
                width: constraints.maxWidth,
                height: constraints.maxWidth * (9 / 16),
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: this.backupImage,
                  fit: BoxFit.cover,
                )),
              );
      },
    );

    var stackedWidgets = <Widget>[imageProvider];
    if (this.canEdit) {
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
      aspectRatio: CropAspectRatio(
        ratioX: 16,
        ratioY: 9,
      ),
      aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: "Crop Banner Image",
          toolbarColor: TrailAppSettings.themePrimarySwatch,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.ratio16x9,
          lockAspectRatio: true),
      iosUiSettings: IOSUiSettings(
        aspectRatioLockEnabled: true,
      ),
    ).then((File croppedFile) {
      var image = decodeImage((croppedFile).readAsBytesSync());
      var scaledImage = copyResize(image, width: 1600, height: 900);
      String scaledImageFilename = croppedFile.path +
          DateTime.now().millisecondsSinceEpoch.toString() +
          '.jpg';
      File(scaledImageFilename)
        ..writeAsBytesSync(encodeJpg(scaledImage, quality: this._imageQuality));
      this._bloc.updateBannerImage(File(scaledImageFilename));
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
                              source: ImageSource.camera, maxHeight: _maxHeight)
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
    return Positioned(
      bottom: 16.0,
      right: 16.0,
      child: FloatingActionButton(
        heroTag: 'changeBannerBtn',
        elevation: 16.0,
        backgroundColor: TrailAppSettings.second.withAlpha(125),
        child: Icon(Icons.add_a_photo),
        onPressed: () {
          Permission.camera.status.then((status) {
            if (status == PermissionStatus.granted) {
              this.showBottomModalSelector();
            } else {
              Permission.camera.request().then((status) {
                print(status);
                if (status == PermissionStatus.granted) {
                  showBottomModalSelector();
                }
              });
            }
          });
        },
      ),
    );
  }
}
