import 'package:alabama_beer_trail/blocs/user_data_bloc.dart';
import 'package:alabama_beer_trail/util/const.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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

  var _userDataBloc = UserDataBloc();

  _ProfileBanner(
      this.imageUrl, this.backupImage, this.canEdit, this.placeholder);

  @override
  Widget build(BuildContext context) {
    Widget imageProvider = this.imageUrl != null
        ? CachedNetworkImage(
            imageUrl: this.imageUrl,
            imageBuilder: (context, imageProvider) => Container(
                  width: double.infinity,
                  height: 140.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
            placeholder: (context, url) => this.placeholder,
            errorWidget: (context, url, error) => Icon(Icons.error))
        : this.backupImage;

    var stackedWidgets = <Widget>[imageProvider];
    if (this.canEdit) {
      stackedWidgets.add(editButton());
    }

    return Stack(
      children: stackedWidgets,
    );
  }

  Widget editButton() {
    return Positioned(
      bottom: 66.0,
      right: 16.0,
      child: FloatingActionButton(
        heroTag: 'changeBannerBtn',
        elevation: 16.0,
        backgroundColor: Constants.colors.second.withAlpha(125),
        child: Icon(Icons.add_a_photo),
        onPressed: () {
          PermissionHandler()
              .checkPermissionStatus(PermissionGroup.camera)
              .then((status) {
            if (status == PermissionStatus.granted) {
              showModalBottomSheet(
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
                            Text(
                                "Where would you like to take the photo from?"),
                            SizedBox(height: 16.0),
                            MaterialButton(
                              minWidth: double.infinity,
                              child: Text("Camera"),
                              onPressed: () {
                                ImagePicker.pickImage(
                                  source: ImageSource.camera,
                                  imageQuality: 75,
                                  maxHeight: 400,
                                ).then((file) {
                                  Navigator.pop(context);
                                  this._userDataBloc.updateBannerImage(file);
                                });
                              },
                            ),
                            MaterialButton(
                              minWidth: double.infinity,
                              child: Text("Photo Gallery"),
                              onPressed: () {
                                ImagePicker.pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 75,
                                  maxHeight: 400,
                                ).then((file) {
                                  Navigator.pop(context);
                                  this._userDataBloc.updateBannerImage(file);
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
            } else {
              PermissionHandler()
                  .requestPermissions([PermissionGroup.camera]).then((status) {
                print(status);
              });
            }
          });
        },
      ),
    );
  }
}
