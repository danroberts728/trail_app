import 'package:alabama_beer_trail/blocs/screen_edit_profile_bloc.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/widgets/profile_user_photo.dart';
import 'package:alabama_beer_trail/widgets/profile_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// The screen to edit the user's profile
///
class EditProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EditProfileScreen();
}

/// The state for the user's edit profile screen
class _EditProfileScreen extends State<EditProfileScreen> {
  /// The user data BLoC
  EditProfileScreenBloc _bloc = EditProfileScreenBloc();

  /// The key for the edit form
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// The birthdate that was selected.
  ///
  /// This is used to work a text input form with a dat
  /// picker widget.
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
              stream: _bloc.stream,
              initialData: _bloc.userData,
              builder: (context, snapshot) {
                var userData = snapshot.data;
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
                                    userData.bannerImageUrl,
                                    backupImage: AssetImage(TrailAppSettings
                                        .defaultBannerImageAssetLocation),
                                    canEdit: true,
                                    placeholder: Container(
                                      color: Colors.white,
                                        child: Center(
                                            child:
                                                CircularProgressIndicator())),
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
                                    ProfileUserPhoto(
                                      userData.profilePhotoUrl,
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
                                    icon: Icon(Icons.person),
                                    labelText: "Name",
                                  ),
                                  initialValue: userData.displayName,
                                  maxLength: 100,
                                  maxLengthEnforced: true,
                                  onSaved: (value) =>
                                      _bloc.updateDisplayName(value),
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.home),
                                    labelText: "Location",
                                    hintText: "City, State",
                                  ),
                                  initialValue: userData.location,
                                  maxLength: 100,
                                  onSaved: (value) =>
                                      _bloc.updateLocation(value),
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.calendar_today),
                                    labelText: "Date of Birth",
                                  ),
                                  controller: TextEditingController(
                                    text: this._selectedBirthDate != null
                                        ? this._selectedBirthDate
                                        : userData.birthDay != null
                                            ? DateFormat("MMM d y")
                                                .format(userData.birthDay)
                                            : '',
                                  ),
                                  onTap: () => showDatePicker(
                                    context: context,
                                    initialDate: _selectedBirthDate != null
                                        ? DateFormat("MMM d y")
                                            .parse(this._selectedBirthDate)
                                        : DateTime.now().subtract(
                                            Duration(days: 7665)), // - 21 years
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
                                      _bloc.updateDob(value),
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: "About You",
                                  ),
                                  initialValue: userData.aboutYou,
                                  maxLines: 5,
                                  maxLengthEnforced: true,
                                  minLines: 1,
                                  maxLength: 140,
                                  onSaved: (value) =>
                                      _bloc.updateAboutYou(value),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ));
  }
}
