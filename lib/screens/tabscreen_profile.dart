import 'dart:async';

import 'package:alabama_beer_trail/blocs/trail_places_bloc.dart';
import 'package:alabama_beer_trail/blocs/user_checkins_bloc.dart';
import 'package:alabama_beer_trail/blocs/user_data_bloc.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/screens/screen_trailplaces.dart';
import 'package:alabama_beer_trail/data/check_in.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/widgets/profile_user_photo.dart';
import 'package:alabama_beer_trail/widgets/profile_banner.dart';
import 'package:alabama_beer_trail/widgets/profile_stat.dart';

import '../blocs/appauth_bloc.dart';

import 'package:flutter/material.dart';

class TabScreenProfile extends StatefulWidget {
  final _TabScreenProfile _state = _TabScreenProfile();

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
            return LayoutBuilder(builder: (context, constraints) {
              var profileImageHeight = constraints.maxWidth * (9 / 16);

              return SingleChildScrollView(
                child: Container(
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
                                  canEdit: false,
                                  placeholder: CircularProgressIndicator(),
                                ),
                                SizedBox(
                                  height: 70,
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
                              top: profileImageHeight,
                              right: 16.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    snapshot.data['displayName'] != null
                                        ? snapshot.data['displayName']
                                        : TrailAppSettings.defaultDisplayName,
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
                                      color: TrailAppSettings.second,
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
                        margin: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
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
                        color: TrailAppSettings.second,
                        indent: 16.0,
                        endIndent: 16.0,
                      ),
                      StreamBuilder(
                        stream: this._userCheckinsBloc.checkInStream,
                        builder: (context, checkInsSnapshot) {
                          return StreamBuilder(
                            stream: this._placesBloc.trailPlaceStream,
                            builder: (context, placesSnapshot) {
                              List<String> visited = List<String>();
                              List<String> notVisited = List<String>();
                              List<String> favorites = List<String>();

                              if (checkInsSnapshot.connectionState ==
                                      ConnectionState.active &&
                                  placesSnapshot.connectionState ==
                                      ConnectionState.active) {
                                List<CheckIn> sData =
                                    checkInsSnapshot.data as List<CheckIn>;

                                sData.forEach((f) {
                                  if (!visited.contains(f.placeId)) {
                                    visited.add(f.placeId);
                                  }
                                });
                                var notVisitedPlaces =
                                    (placesSnapshot.data as List<TrailPlace>)
                                        .where((p) => !visited.contains(p.id))
                                        .toList();
                                notVisitedPlaces.forEach((p) {
                                  notVisited.add(p.id);
                                });

                                favorites =
                                    List.from(snapshot.data['favorites']);
                              }
                              return Container(
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        ProfileStat(
                                          value: visited.length,
                                          postText: "Visited",
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                settings: RouteSettings(
                                                    name: 'Visited'),
                                                builder: (context) =>
                                                    TrailPlacesScreen(
                                                  appBarTitle: "Visited",
                                                  placeIds: visited,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        ProfileStat(
                                            value: notVisited.length,
                                            postText: "Not Visited",
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  settings: RouteSettings(
                                                      name: 'Not Visisted'),
                                                  builder: (context) =>
                                                      TrailPlacesScreen(
                                                    appBarTitle: "Not Visited",
                                                    placeIds: notVisited,
                                                  ),
                                                ),
                                              );
                                            }),
                                        ProfileStat(
                                            value: favorites.length,
                                            postText: "Favorites",
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  settings: RouteSettings(
                                                      name: 'Favorites'),
                                                  builder: (context) =>
                                                      TrailPlacesScreen(
                                                    appBarTitle: "Favorites",
                                                    placeIds: favorites,
                                                  ),
                                                ),
                                              );
                                            }),
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
                ),
              );
            });
          }
        });
  }

  FutureOr onValue(void value) {}
}
