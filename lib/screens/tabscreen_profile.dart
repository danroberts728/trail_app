import 'dart:async';

import 'package:alabama_beer_trail/blocs/trail_places_bloc.dart';
import 'package:alabama_beer_trail/blocs/user_checkins_bloc.dart';
import 'package:alabama_beer_trail/blocs/user_data_bloc.dart';
import 'package:alabama_beer_trail/screens/tabscreen_profile_edit.dart';
import 'package:alabama_beer_trail/util/check_in.dart';
import 'package:alabama_beer_trail/util/const.dart';
import 'package:alabama_beer_trail/widgets/profile_user_photo.dart';
import 'package:alabama_beer_trail/widgets/profile_banner.dart';
import 'package:alabama_beer_trail/widgets/profile_stat.dart';

import '../util/appauth.dart';
import 'tabscreen_child.dart';

import 'package:flutter/material.dart';

class TabScreenProfile extends StatefulWidget implements TabScreenChild {
  final _TabScreenProfile _state = _TabScreenProfile();

  List<IconButton> getAppBarActions() {
    return _state.getAppBarActions();
  }

  @override
  State<StatefulWidget> createState() => _state;
}

class _TabScreenProfile extends State<TabScreenProfile> {
  SigninStatus signinStatus = SigninStatus.NOT_SIGNED_IN;

  UserDataBloc _userDataBloc = UserDataBloc();
  UserCheckinsBloc _userCheckinsBloc = UserCheckinsBloc();
  TrailPlacesBloc _placesBloc = TrailPlacesBloc();

  @override
  Widget build(BuildContext context) {
    String userEmail = AppAuth().user.email;

    return StreamBuilder(
      stream: this._userDataBloc.userDataStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          return Container(
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
                            backupImage: AssetImage(Constants
                                .options.defaultBannerImageAssetLocation),
                            canEdit: false,
                            placeholder: CircularProgressIndicator(),
                          ),
                          SizedBox(
                            height: 70.0,
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 16.0,
                        child: ProfileUserPhoto(
                          snapshot.data['profilePhotoUrl'],
                          backupImage: AssetImage(
                              'assets/images/defaultprofilephoto.png'),
                          canEdit: false,
                          placeholder: CircularProgressIndicator(),
                        ),
                      ),
                      Positioned(
                        top: 142.0,
                        right: 16.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              snapshot.data['displayName'] != null
                                  ? snapshot.data['displayName']
                                  : Constants.options.defaultDisplayName,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              userEmail,
                              style: TextStyle(
                                color: Constants.colors.second,
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
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 5.0,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  child: Text(
                    snapshot.data['aboutYou'] != null
                        ? snapshot.data['aboutYou']
                        : '',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          color: Colors.black54,
                          size: 16.0,
                        ),
                        Text(
                          snapshot.data['location'] != null
                              ? snapshot.data['location']
                              : '',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    )),
                Divider(
                  color: Constants.colors.second,
                  indent: 16.0,
                  endIndent: 16.0,
                ),
                StreamBuilder(
                  stream: this._userCheckinsBloc.checkInStream,
                  builder: (context, checkInsSnapshot) {
                    return StreamBuilder(
                      stream: this._placesBloc.trailPlaceStream,
                      builder: (context, placesSnapshot) {
                        int visitedCount;
                        int notVisitedCount;
                        if (checkInsSnapshot.connectionState ==
                            ConnectionState.active) {
                          List<CheckIn> sData =
                              checkInsSnapshot.data as List<CheckIn>;
                          List<String> uniquePlacesVisited = List<String>();
                          sData.forEach((f) {
                            if (!uniquePlacesVisited.contains(f.placeId)) {
                              uniquePlacesVisited.add(f.placeId);
                            }
                          });
                          visitedCount = uniquePlacesVisited.length;
                          notVisitedCount =
                              placesSnapshot.data.length - visitedCount;
                        }
                        return Container(
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 5.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  ProfileStat(
                                    value: visitedCount,
                                    postText: "Visited",
                                    onPressed: () => null,
                                  ),
                                  ProfileStat(
                                    value: notVisitedCount,
                                    postText: "Not Visited",
                                    onPressed: () => null,
                                  ),
                                  ProfileStat(
                                    value: snapshot.data['favorites'].length,
                                    postText: "Favorites",
                                    onPressed: () => null,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }

  List<IconButton> getAppBarActions() {
    return <IconButton>[
      IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EditProfileScreen(userId: AppAuth().user.uid)));
        },
      ),
      IconButton(
        icon: Icon(Icons.power_settings_new),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: new Text("Log out - ${AppAuth().user.email}"),
                  content: new Text(
                      "Are you sure you want to log out from your account?"),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("Confirm"),
                      onPressed: () => AppAuth().logout(),
                    ),
                    new FlatButton(
                      child: new Text("Cancel"),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                );
              });
        },
      )
    ];
  }

  FutureOr onValue(void value) {}
}
