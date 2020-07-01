import 'package:alabama_beer_trail/blocs/trail_places_bloc.dart';
import 'package:alabama_beer_trail/blocs/trail_trophy_bloc.dart';
import 'package:alabama_beer_trail/blocs/user_checkins_bloc.dart';
import 'package:alabama_beer_trail/blocs/user_data_bloc.dart';
import 'package:alabama_beer_trail/screens/tabscreen_profile/profile_trophies_area.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/screens/tabscreen_profile/profile_stats_area.dart';
import 'package:alabama_beer_trail/screens/tabscreen_profile/proflie_top_area.dart';

import '../../blocs/appauth_bloc.dart';

import 'package:flutter/material.dart';

/// The tab screen for the user's own profile
///
class TabScreenProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabScreenProfile();
}

/// The state for the profile tab
class _TabScreenProfile extends State<TabScreenProfile> {
  /// The user's current sign in status
  SigninStatus signinStatus = SigninStatus.NOT_SIGNED_IN;

  // User Data BLoC
  final UserDataBloc _userDataBloc = UserDataBloc();

  // User Checkins BLoC
  final UserCheckinsBloc _userCheckinsBloc = UserCheckinsBloc();

  // Trail Places BLoC
  final TrailPlacesBloc _trailPlacesBloc = TrailPlacesBloc();

  // Trophies BLoC
  final TrailTrophyBloc _trailTrophyBloc = TrailTrophyBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _userDataBloc.userDataStream,
      initialData: _userDataBloc.userData,
      builder: (context, userDataSnapshot) {
        return StreamBuilder(
          stream: _userCheckinsBloc.checkInStream,
          initialData: _userCheckinsBloc.checkIns,
          builder: (context, checkInSnapshot) {
            return StreamBuilder(
                stream: _trailPlacesBloc.trailPlaceStream,
                initialData: _trailPlacesBloc.trailPlaces,
                builder: (context, trailPlacesSnapshot) {
                  return StreamBuilder(
                      stream: _trailTrophyBloc.trailTrophiesStream,
                      initialData: _trailTrophyBloc.trailTrophies,
                      builder: (context, trailTrophiesSnapshot) {
                        return Container(
                          child: CustomScrollView(
                            slivers: <Widget>[
                              // Top Area (images, name, email, member since, about You, and location)
                              SliverToBoxAdapter(
                                child: ProfileTopArea(
                                  userData: userDataSnapshot.data,
                                ),
                              ),
                              // Divider Line
                              SliverToBoxAdapter(
                                child: Divider(
                                  color: TrailAppSettings.second,
                                ),
                              ),
                              // Stats Area
                              SliverToBoxAdapter(
                                child: ProfileStatsArea(
                                  userCheckIns: checkInSnapshot.data,
                                  trailPlaces: trailPlacesSnapshot.data,
                                ),
                              ),
                              // Divider Line
                              SliverToBoxAdapter(
                                child: Divider(
                                  color: TrailAppSettings.second,
                                ),
                              ),
                              // Trophy header
                              SliverToBoxAdapter(
                                child: Text(
                                  "Trophies",                                  
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: TrailAppSettings.subHeadingColor,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // Spacer
                              SliverToBoxAdapter(
                                child: SizedBox(height: 16.0,),
                              ),
                              // Trophy Area
                              ProfileTrophiesArea(
                                trailTrophies: trailTrophiesSnapshot.data,
                                userData: userDataSnapshot.data,
                              ),
                              // Spacer
                              SliverToBoxAdapter(
                                child: SizedBox(height: 80.0,),
                              ),
                            ],
                          ),
                        );
                      });
                });
          },
        );
      },
    );
  }
}
