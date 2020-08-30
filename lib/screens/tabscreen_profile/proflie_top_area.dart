import 'package:alabama_beer_trail/util/appauth.dart';
import 'package:alabama_beer_trail/data/user_data.dart';
import 'package:alabama_beer_trail/blocs/profile_top_area_bloc.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/widgets/profile_banner.dart';
import 'package:alabama_beer_trail/widgets/profile_user_photo.dart';
import 'package:flutter/material.dart';

class ProfileTopArea extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileTopArea();
}

class _ProfileTopArea extends State<ProfileTopArea> {
  String userEmail = AppAuth().user.email;

  @override
  Widget build(BuildContext context) {
    final _profileTopAreaBloc = ProfileTopAreaBloc();

    return LayoutBuilder(
      builder: (context, constraints) {
        var profileImageHeight = constraints.maxWidth * (9 / 16);

        return StreamBuilder(
          stream: _profileTopAreaBloc.stream,
          initialData: _profileTopAreaBloc.userData,
          builder: (context, snapshot) {
            var userData = snapshot.data as UserData;
            return Container(
              child: Column(
                children: <Widget>[
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          ProfileBanner(
                            userData.bannerImageUrl,
                            backupImage: AssetImage(TrailAppSettings
                                .defaultBannerImageAssetLocation),
                            canEdit: false,
                            placeholder: CircularProgressIndicator(),
                          ),
                          SizedBox(
                            height: 74,
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 16.0,
                        child: ProfileUserPhoto(
                          userData.profilePhotoUrl,
                          backupImage: AssetImage(
                              'assets/images/defaultprofilephoto.png'),
                          canEdit: false,
                          placeholder: CircularProgressIndicator(),
                        ),
                      ),
                      Positioned(
                        top: profileImageHeight,
                        right: 16.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              userData.displayName != null &&
                                      userData.displayName.isNotEmpty
                                  ? userData.displayName
                                  : TrailAppSettings.defaultDisplayName,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: TrailAppSettings.mainHeadingColor,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              userEmail,
                              style: TextStyle(
                                color: TrailAppSettings.subHeadingColor,
                              ),
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  color: Colors.grey,
                                ),
                                Text(
                                  " Since ${AppAuth().user.createdDate}",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
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
          },
        );
      },
    );
  }
}
