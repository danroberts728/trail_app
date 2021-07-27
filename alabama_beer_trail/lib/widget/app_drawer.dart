// Copyright (c) 2020, Fermented Software.
import 'package:trail_database/trail_database.dart';
import 'package:trail_database/domain/user_data.dart';
import 'package:alabama_beer_trail/widget/screen_about.dart';
import 'package:alabama_beer_trail/widget/screen_privacy_policy.dart';
import 'package:trail_profile/trail_profile.dart';
import 'package:trailtab_places/trailtab_places.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:trail_auth/trail_auth.dart';
import 'package:alabama_beer_trail/widget/app_drawer_menu_item.dart';
import 'package:alabama_beer_trail/widget/app_drawer_stats.dart';
import 'package:trail_profile/widget/profile_user_photo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// The main drawer for the app
class AppDrawer extends StatefulWidget {
  final bool isUserLoggedIn;

  const AppDrawer({Key key, @required this.isUserLoggedIn}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppDrawer();
}

class _AppDrawer extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamBuilder(
        stream: TrailDatabase().userDataStream,
        initialData: TrailDatabase().userData,
        builder: (context, AsyncSnapshot<UserData> userSnapshot) => Container(
          child: ListView(
            children: [
              // User Photo
              Visibility(
                visible: widget.isUserLoggedIn,
                child: Container(
                  padding: EdgeInsets.only(top: 24.0, left: 16.0, right: 16.0),
                  child: ProfileUserPhoto(
                    userSnapshot.data.profilePhotoUrl,
                    canEdit: false,
                    placeholder: CircularProgressIndicator(),
                    backupImage:
                        AssetImage('assets/images/defaultprofilephoto.png'),
                    height: 75,
                    width: 75,
                  ),
                ),
              ),
              // User Name
              Visibility(
                visible: widget.isUserLoggedIn,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    userSnapshot.data.displayName,
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // User Email
              Visibility(
                visible: widget.isUserLoggedIn,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    TrailAuth().user != null ? TrailAuth().user.email : "",
                    maxLines: 3,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ),
              // Line
              Divider(
                height: 32.0,
              ),
              // Stats
              Visibility(
                visible: widget.isUserLoggedIn,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: AppDrawerStats(),
                ),
              ),
              // Log In Button
              Visibility(
                visible: !widget.isUserLoggedIn,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).buttonColor,
                      elevation: 8.0,
                    ),
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: RouteSettings(name: 'Sign in Page'),
                        builder: (context) => ScreenSignIn(),
                      ),
                    ),
                  ),
                ),
              ),
              // Line
              Divider(
                height: 32.0,
              ),
              // Profile
              Visibility(
                visible: widget.isUserLoggedIn,
                child: AppDrawerMenuItem(
                    iconColor: Theme.of(context).buttonColor,
                    iconData: Icons.person,
                    name: "Profile",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          settings: RouteSettings(name: 'Profile'),
                          builder: (context) => TrailProfile(
                            defaultBannerImageAssetName:
                                'assets/images/fthglasses.jpg',
                            defaultDisplayName: " ",
                            defaultProfilePhotoAssetName:
                                'assets/images/defaultprofilephoto.png',
                          ),
                        ),
                      );
                    }),
              ),
              // Line
              Visibility(
                visible: widget.isUserLoggedIn,
                child: Divider(
                  height: 32.0,
                ),
              ),
              // About
              AppDrawerMenuItem(
                  iconColor: Theme.of(context).buttonColor,
                  iconData: Icons.info,
                  name: "About",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: RouteSettings(name: 'About'),
                        builder: (context) => AboutScreen(),
                      ),
                    );
                  }),
              // Submit Feedback
              AppDrawerMenuItem(
                iconColor: Theme.of(context).buttonColor,
                iconData: Icons.chat,
                name: "Submit Feedback",
                onTap: () {
                  Navigator.pop(context);
                  launch("https://freethehops.org/apps/submit-feedback");
                },
              ),
              // Privacy Policy
              AppDrawerMenuItem(
                  iconColor: Theme.of(context).buttonColor,
                  iconData: Icons.privacy_tip,
                  name: "Privacy Policy",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: RouteSettings(name: 'Privacy Policy'),
                        builder: (context) => ScreenPrivacyPolicy(),
                      ),
                    );
                  }),
              // Log Out
              Visibility(
                visible: widget.isUserLoggedIn,
                child: AppDrawerMenuItem(
                  iconColor: Theme.of(context).buttonColor,
                  iconData: Icons.logout,
                  name: "Log Out",
                  onTap: () => TrailAuth().logout(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
