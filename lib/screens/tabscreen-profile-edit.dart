import 'package:alabama_beer_trail/blocs/user_data_bloc.dart';
import 'package:alabama_beer_trail/util/const.dart';
import 'package:alabama_beer_trail/widgets/profile-photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfileScreen extends StatefulWidget {
  final String userId;

  EditProfileScreen({@required this.userId});

  @override
  State<StatefulWidget> createState() => _EditProfileScreen(this.userId);
}

class _EditProfileScreen extends State<EditProfileScreen> {
  final String userId;

  _EditProfileScreen(this.userId);

  UserDataBloc _userDataBloc = UserDataBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.save),
            color: Colors.white,
          ),
        ],
      ),
      body: StreamBuilder(
        stream: this._userDataBloc.userDataStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                height: 140.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: snapshot.data['bannerImageUrl'] !=
                                            null
                                        ? NetworkImage(
                                            snapshot.data['bannerImageUrl'])
                                        : AssetImage(Constants.options
                                            .defaultBannerImageAssetLocation),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 50.0,
                              )
                            ],
                          ),
                          Positioned(
                            bottom: 66.0,
                            right: 16.0,
                            child: FloatingActionButton(
                              heroTag: 'changeBannerBtn',
                              elevation: 16.0,
                              backgroundColor:
                                  Constants.colors.second.withAlpha(125),
                              child: Icon(Icons.add_a_photo),
                              onPressed: () {
                                PermissionHandler()
                                    .checkPermissionStatus(
                                        PermissionGroup.camera)
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
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
                                                        source:
                                                            ImageSource.camera,
                                                        imageQuality: 75,
                                                            maxHeight: 400,
                                                      ).then((file) {
                                                        Navigator.pop(context);
                                                        this
                                                            ._userDataBloc
                                                            .updateBannerImage(
                                                                file);
                                                      });
                                                    },
                                                  ),
                                                  MaterialButton(
                                                    minWidth: double.infinity,
                                                    child:
                                                        Text("Photo Gallery"),
                                                    onPressed: () {
                                                      ImagePicker.pickImage(
                                                        source:
                                                            ImageSource.gallery,
                                                        imageQuality: 75,
                                                            maxHeight: 400,
                                                      ).then((file) {
                                                        Navigator.pop(context);
                                                        this
                                                            ._userDataBloc
                                                            .updateBannerImage(
                                                                file);
                                                      });
                                                    },
                                                  ),
                                                  MaterialButton(
                                                    minWidth: double.infinity,
                                                    child: Text("Cancel"),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  )
                                                ],
                                              ));
                                        });
                                  } else {
                                    PermissionHandler().requestPermissions([
                                      PermissionGroup.camera
                                    ]).then((status) {
                                      print(status);
                                    });
                                  }
                                });
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 16.0,
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                ProfilePhoto(
                                  image: snapshot.data['profilePhotoUrl'] !=
                                          null
                                      ? NetworkImage(
                                          snapshot.data['profilePhotoUrl'])
                                      : AssetImage(
                                          'assets/images/defaultprofilephoto.png'),
                                ),
                                FloatingActionButton(
                                  heroTag: 'btn2',
                                  elevation: 16.0,
                                  backgroundColor: Colors.transparent,
                                  child: Icon(Icons.add_a_photo),
                                  onPressed: () {
                                    PermissionHandler()
                                        .checkPermissionStatus(
                                            PermissionGroup.camera)
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
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      SizedBox(height: 16.0),
                                                      Text(
                                                          "Where would you like to take the photo from?"),
                                                      SizedBox(height: 16.0),
                                                      MaterialButton(
                                                        minWidth:
                                                            double.infinity,
                                                        child: Text("Camera"),
                                                        onPressed: () {
                                                          ImagePicker.pickImage(
                                                            source: ImageSource
                                                                .camera,
                                                            imageQuality: 75,
                                                            maxHeight: 400,
                                                          ).then((file) {
                                                            Navigator.pop(context);
                                                            this
                                                                ._userDataBloc
                                                                .updateProfileImage(
                                                                    file);
                                                          });
                                                        },
                                                      ),
                                                      MaterialButton(
                                                        minWidth:
                                                            double.infinity,
                                                        child: Text(
                                                            "Photo Gallery"),
                                                        onPressed: () {
                                                          ImagePicker.pickImage(
                                                            source: ImageSource
                                                                .gallery,
                                                            imageQuality: 75,
                                                            maxHeight: 400,
                                                          ).then((file) {
                                                            Navigator.pop(context);
                                                            this
                                                                ._userDataBloc
                                                                .updateProfileImage(
                                                                    file);
                                                          });
                                                        },
                                                      ),
                                                      MaterialButton(
                                                        minWidth:
                                                            double.infinity,
                                                        child: Text("Cancel"),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      )
                                                    ],
                                                  ));
                                            });
                                      } else {
                                        PermissionHandler().requestPermissions([
                                          PermissionGroup.camera
                                        ]).then((status) {
                                          print(status);
                                        });
                                      }
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
