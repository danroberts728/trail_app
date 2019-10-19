import 'package:alabama_beer_trail/blocs/user_data_bloc.dart';
import 'package:alabama_beer_trail/util/const.dart';
import 'package:alabama_beer_trail/widgets/profile_photo.dart';
import 'package:alabama_beer_trail/widgets/profile_banner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _selectedBirthDate;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          _formKey.currentState.save();
          return Future.value(true);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Edit Profile"),
          ),
          body: SingleChildScrollView(
            child: StreamBuilder(
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
                                    ProfileBanner(
                                      snapshot.data['bannerImageUrl'],
                                      backupImage: AssetImage(Constants.options
                                          .defaultBannerImageAssetLocation),
                                      canEdit: true,
                                      placeholder: CircularProgressIndicator(),
                                    ),
                                    SizedBox(
                                      height: 70.0,
                                    )
                                  ],
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 16.0,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      ProfilePhoto(
                                        image: snapshot
                                                    .data['profilePhotoUrl'] !=
                                                null
                                            ? CachedNetworkImageProvider(
                                                snapshot
                                                    .data['profilePhotoUrl'])
                                            : AssetImage(
                                                'assets/images/defaultprofilephoto.png'),
                                      ),
                                      FloatingActionButton(
                                        heroTag: 'btn2',
                                        mini: true,
                                        elevation: 16.0,
                                        backgroundColor: Constants.colors.second
                                            .withAlpha(125),
                                        child: Icon(
                                          Icons.add_a_photo,
                                        ),
                                        onPressed: () {
                                          PermissionHandler()
                                              .checkPermissionStatus(
                                                  PermissionGroup.camera)
                                              .then((status) {
                                            if (status ==
                                                PermissionStatus.granted) {
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
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            SizedBox(
                                                                height: 16.0),
                                                            Text(
                                                                "Where would you like to take the photo from?"),
                                                            SizedBox(
                                                                height: 16.0),
                                                            MaterialButton(
                                                              minWidth: double
                                                                  .infinity,
                                                              child: Text(
                                                                  "Camera"),
                                                              onPressed: () {
                                                                ImagePicker
                                                                    .pickImage(
                                                                  source:
                                                                      ImageSource
                                                                          .camera,
                                                                  imageQuality:
                                                                      75,
                                                                  maxHeight:
                                                                      400,
                                                                ).then((file) {
                                                                  Navigator.pop(
                                                                      context);
                                                                  this
                                                                      ._userDataBloc
                                                                      .updateProfileImage(
                                                                          file);
                                                                });
                                                              },
                                                            ),
                                                            MaterialButton(
                                                              minWidth: double
                                                                  .infinity,
                                                              child: Text(
                                                                  "Photo Gallery"),
                                                              onPressed: () {
                                                                ImagePicker
                                                                    .pickImage(
                                                                  source:
                                                                      ImageSource
                                                                          .gallery,
                                                                  imageQuality:
                                                                      75,
                                                                  maxHeight:
                                                                      400,
                                                                ).then((file) {
                                                                  Navigator.pop(
                                                                      context);
                                                                  this
                                                                      ._userDataBloc
                                                                      .updateProfileImage(
                                                                          file);
                                                                });
                                                              },
                                                            ),
                                                            MaterialButton(
                                                              minWidth: double
                                                                  .infinity,
                                                              child: Text(
                                                                  "Cancel"),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            )
                                                          ],
                                                        ));
                                                  });
                                            } else {
                                              PermissionHandler()
                                                  .requestPermissions([
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
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: "Name",
                                    ),
                                    initialValue: snapshot.data['displayName'],
                                    maxLength: 100,
                                    maxLengthEnforced: true,
                                    onSaved: (value) =>
                                        _userDataBloc.updateDisplayName(value),
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: "Location",
                                      hintText: "City, State",
                                    ),
                                    initialValue: snapshot.data['location'],
                                    maxLength: 100,
                                    onSaved: (value) =>
                                        _userDataBloc.updateLocation(value),
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: "Date of Birth",
                                    ),
                                    controller: TextEditingController(
                                      text: this._selectedBirthDate != null
                                          ? this._selectedBirthDate
                                          : snapshot.data['birthdate'] != null
                                              ? DateFormat("MMM d y").format(
                                                  snapshot.data['birthdate']
                                                      .toDate())
                                              : '',
                                    ),
                                    onTap: () => showDatePicker(
                                      context: context,
                                      initialDate: _selectedBirthDate != null
                                          ? DateFormat("MMM d y")
                                              .parse(this._selectedBirthDate)
                                          : DateTime.now().subtract(Duration(
                                              days: 7665)), // - 21 years
                                      firstDate: DateTime(1960),
                                      lastDate: DateTime.now().subtract(
                                          Duration(days: 7665)), // - 21 years
                                    ).then((value) {
                                      setState(() {
                                        _selectedBirthDate =
                                            DateFormat("MMM d y").format(value);
                                      });
                                    }),
                                    onSaved: (value) =>
                                        _userDataBloc.updateDob(value),
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: "About You",
                                    ),
                                    initialValue: snapshot.data['aboutYou'],
                                    maxLines: 5,
                                    maxLengthEnforced: true,
                                    minLines: 1,
                                    maxLength: 140,
                                    onSaved: (value) =>
                                        _userDataBloc.updateAboutYou(value),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ));
  }
}
