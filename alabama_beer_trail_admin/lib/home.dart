import 'package:beer_trail_admin/app_auth.dart';
import 'package:beer_trail_admin/screens/dashboard/dashboard.dart';
import 'package:beer_trail_admin/screens/trail_admin_screen.dart';

import 'package:beer_trail_admin/screens/trail_places/trail_places.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trail_database/trail_database.dart';

class Home extends StatefulWidget {
  final String displayName;
  final String profilePhotoUrl;

  const Home(
      {Key key, @required this.displayName, @required this.profilePhotoUrl})
      : assert(displayName != null && profilePhotoUrl != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<Home> {

  _Home() {
    // Set up database to include unpublished data
    TrailDatabase(includeUnpublished: true);
  }

  Widget _body = TrailAdminScreen(
    title: "Dashboard",
    body: DashBoard(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alabama Beer Trail Admin"),
      ),
      drawer: Container(
        width: 400.0,
        color: Colors.white,
        child: ListView(
          children: [
            AppDrawerMenuItem(
              iconData: Icons.dashboard,
              name: "Dashboard",
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _body = DashBoard();
                });
              },
            ),
            AppDrawerMenuItem(
              iconData: Icons.location_on,
              name: "Trail Places",
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _body = TrailPlaces();
                });
              },
            ),
            AppDrawerMenuItem(
              iconData: Icons.emoji_events,
              name: "Trail Trophies",
              onTap: () {
              },
            ),
            AppDrawerMenuItem(
                iconData: Icons.logout,
                name: "Logout",
                onTap: () => AppAuth(FirebaseAuth.instance).logout()),
          ],
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: _body,
    );
  }
}

/// A menu item for the app's main drawer menu
class AppDrawerMenuItem extends StatelessWidget {
  final IconData iconData;
  final Color iconColor;
  final double iconSize;
  final String name;
  final Color nameColor;
  final double nameSize;
  final void Function() onTap;

  const AppDrawerMenuItem(
      {Key key,
      @required this.iconData,
      @required this.name,
      @required this.onTap,
      this.iconColor = Colors.black54,
      this.iconSize = 22.0,
      this.nameColor = Colors.black45,
      this.nameSize = 18.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: <Widget>[
            Icon(
              iconData,
              color: iconColor,
              size: iconSize,
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(name,
                style: TextStyle(
                  fontSize: nameSize,
                  color: nameColor,
                )),
          ],
        ),
      ),
    );
  }
}
