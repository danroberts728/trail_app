// Copyright (c) 2020, Fermented Software.
import 'package:trail_database/trail_database.dart';
import 'package:trail_profile/widget/screen_edit_profile.dart';
import 'package:trail_auth/trail_auth.dart';
import 'package:trail_database/domain/user_data.dart';
import 'package:trail_profile/bloc/profile_top_area_bloc.dart';
import 'package:trail_profile/widget/profile_banner.dart';
import 'package:trail_profile/widget/profile_user_photo.dart';
import 'package:flutter/material.dart';

/// The top area of the user profile, including the banner
/// image, the user profile photo, name, and start date
class ProfileTopArea extends StatefulWidget {
  final String defaultProfilePhotoAssetName;
  final String defaultBannerImageAssetName;
  final String defaultDisplayName;

  const ProfileTopArea(
      {Key key,
      @required this.defaultProfilePhotoAssetName,
      @required this.defaultBannerImageAssetName,
      @required this.defaultDisplayName})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileTopArea();
}

class _ProfileTopArea extends State<ProfileTopArea> {
  @override
  Widget build(BuildContext context) {
    final _profileTopAreaBloc = ProfileTopAreaBloc(TrailDatabase());

    return LayoutBuilder(
      builder: (context, constraints) {
        var profileImageHeight = constraints.maxWidth * (9 / 16);

        return StreamBuilder(
          stream: _profileTopAreaBloc.stream,
          initialData: _profileTopAreaBloc.userData,
          builder: (context, snapshot) {
            if (snapshot == null) {
              return Container(
                height: profileImageHeight,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              return Container(
                height: profileImageHeight,
                child: Center(
                  child: Icon(Icons.error),
                ),
              );
            } else {
              var userData = snapshot.data as UserData;
              return Container(
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: [
                        /// Profile Banner, name, and Since date
                        Positioned(
                          child: Column(
                            children: <Widget>[
                              ProfileBanner(
                                userData.bannerImageUrl,
                                backupImage: AssetImage(widget.defaultBannerImageAssetName),
                                canEdit: false,
                                placeholder: CircularProgressIndicator(),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    right: 16.0,
                                    left: constraints.maxWidth * .4),
                                alignment: Alignment.topRight,
                                child: Text(
                                  userData.displayName != null &&
                                          userData.displayName.isNotEmpty
                                      ? userData.displayName
                                      : widget.defaultDisplayName,
                                  maxLines: 3,
                                  textAlign: TextAlign.end,
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Icon(
                                      Icons.date_range,
                                      color: Theme.of(context).textTheme.subtitle1.color,
                                    ),
                                    Text(
                                      " Since ${TrailAuth().user.createdDate}",
                                      style: TextStyle(
                                        color: Theme.of(context).textTheme.subtitle1.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Edit Profile Button
                        Positioned(
                          top: profileImageHeight - 55,
                          right: 16.0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white54,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(
                                  color: Theme.of(context).buttonColor,
                                ),
                              ),
                            ),
                            child: Text(
                              "Edit Profile",
                              style: TextStyle(
                                color: Theme.of(context).buttonColor,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  settings: RouteSettings(
                                    name: 'Edit Profile',
                                  ),
                                  builder: (context) => EditProfileScreen(
                                    defaultBannerImageAssetName: widget.defaultBannerImageAssetName,
                                    defaultDisplayName: widget.defaultDisplayName,
                                    defaultProfilePhotoAssetName: widget.defaultProfilePhotoAssetName,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        // Profile Photo
                        Positioned(
                          top: profileImageHeight - 43,
                          left: 16.0,
                          child: ProfileUserPhoto(
                            userData.profilePhotoUrl,
                            backupImage: AssetImage(
                                'assets/images/defaultprofilephoto.png'),
                            canEdit: false,
                            placeholder: CircularProgressIndicator(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                        child: Text(
                          userData.aboutYou != null ? userData.aboutYou : '',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          userData.location != null &&
                                  userData.location.isNotEmpty
                              ? Icon(
                                  Icons.location_on,
                                  color: Colors.black54,
                                  size: 16.0,
                                )
                              : SizedBox(),
                          Text(
                            userData.location != null &&
                                    userData.location.isNotEmpty
                                ? userData.location
                                : '',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        );
      },
    );
  }
}
