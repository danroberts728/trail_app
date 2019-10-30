import 'package:alabama_beer_trail/blocs/user_data_bloc.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/widgets/profile_user_photo.dart';
import 'package:alabama_beer_trail/widgets/profile_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

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
                                      backupImage: AssetImage(TrailAppSettings
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
                                      ProfileUserPhoto( snapshot.data['profilePhotoUrl'],
                                        backupImage: AssetImage(
                                                'assets/images/defaultprofilephoto.png'),
                                        canEdit: true,
                                        placeholder: CircularProgressIndicator(),
                                      ),
                                      
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
