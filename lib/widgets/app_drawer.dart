// Copyright (c) 2020, Fermented Software.
import 'package:beer_trail_database/trail_database.dart';
import 'package:beer_trail_database/domain/user_data.dart';
import 'package:beer_trail_app/screens/screen_about.dart';
import 'package:beer_trail_app/screens/screen_privacy_policy.dart';
import 'package:beer_trail_app/screens/screen_profile/screen_profile.dart';
import 'package:beer_trail_app/screens/screen_sign_in.dart';
import 'package:beer_trail_app/screens/screen_passport.dart';
import 'package:beer_trail_app/util/app_launcher.dart';
import 'package:trail_auth/trail_auth.dart';
import 'package:beer_trail_app/util/trail_app_settings.dart';
import 'package:beer_trail_app/widgets/app_drawer_menu_item.dart';
import 'package:beer_trail_app/widgets/app_drawer_stats.dart';
import 'package:beer_trail_app/widgets/profile_user_photo.dart';
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
                    style: TextStyle(
                      height: 1.5,
                      fontSize: 14.0,
                      color: TrailAppSettings.subHeadingColor,
                      fontWeight: FontWeight.normal,
                    ),
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
                  child: RaisedButton(
                    color: TrailAppSettings.actionLinksColor,
                    elevation: 8.0,
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
                    iconData: Icons.person,
                    name: "Profile",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          settings: RouteSettings(name: 'Profile'),
                          builder: (context) => ScreenProfile(),
                        ),
                      );
                    }),
              ),
              // Passport
              Visibility(
                visible: widget.isUserLoggedIn,
                child: AppDrawerMenuItem(
                    iconData: Icons.book,
                    name: "Passport",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          settings: RouteSettings(name: 'Passport'),
                          builder: (context) => ScreenPassport(),
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
                  iconData: Icons.chat,
                  name: "Submit Feedback",
                  onTap: () {
                    Navigator.pop(context);
                    AppLauncher()
                        .openWebsite(TrailAppSettings.submitFeedbackUrl);
                  }),
              // Privacy Policy
              AppDrawerMenuItem(
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
