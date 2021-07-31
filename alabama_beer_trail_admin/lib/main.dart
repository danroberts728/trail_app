import 'package:beer_trail_admin/app_theme.dart';
import 'package:beer_trail_admin/home.dart';
import 'package:beer_trail_admin/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
  
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((app) {
    runApp(BeerTrailAdminApp());
  });
} 

class BeerTrailAdminApp extends StatefulWidget {  
  @override
  State<StatefulWidget> createState() => _BeerTrailAdminApp();
}

class _BeerTrailAdminApp extends State<BeerTrailAdminApp> {
  bool _isAdminUser = false;
  String _displayName = "";
  String _profilePhotoUrl = "";

  @override
  void initState() {
    _retrieveUserInfo();
    FirebaseAuth.instance.authStateChanges().listen(_onAuthChange);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: makeAppTheme(),
      home: _isAdminUser ?? false
        ? Home(displayName: _displayName, profilePhotoUrl: _profilePhotoUrl,)
        : SignInScreen(),
    );
  }

  
  Future<void> _retrieveUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isAdminUser = prefs.containsKey('is_trail_admin')
        ? prefs.getBool('is_trail_admin')
        : false;
    var displayName = prefs.containsKey('displayName')
        ? prefs.getString('displayName')
        : null;
    var profilePhotoUrl = prefs.containsKey('profilePhotoUrl')
        ? prefs.getString('profilePhotoUrl')
        : null;
    if (isAdminUser) {
      setState(() {
        _isAdminUser = true;
        _displayName = displayName;
        _profilePhotoUrl = profilePhotoUrl;
      });      
    } else {
      setState(() {
        _isAdminUser = false;
        _displayName = "";
        _profilePhotoUrl = "";
      });
    }
  }

  Future<void> _onAuthChange(fbUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    if(prefs.containsKey('is_trail_admin') && prefs.getBool('is_trail_admin')) {
      // By default, we use the share preferences to see if this user has already
      // logged in. This prevents log out when reload is hit. To properly log out 
      // the user, the AppAuth object must set the is_trail_admin pref to false.
      setState(() {
        _isAdminUser = true;
        _displayName = prefs.containsKey('displayName') ? prefs.getString('displayName') : "";
        _profilePhotoUrl = prefs.containsKey('profilePhotoUrl') ? prefs.getString('profilePhotoUrl') : "";
      });      
    } else if (fbUser == null) {
      // The most likely scenario here is a logout action. The AppAuth object changed the state
      // AND set the preference 'is_trail_admin' to false
      setState(() {
        _isAdminUser = false;
        _displayName = "";
        _profilePhotoUrl = ""; 
      }); 
    } else {
      // The most likely scenario  here is a new login action. The preference 'is_trail_admin' is not
      // set or set to false, but the auth has changed to at least an actual user. We need to retrieve
      // the user data to ensure that the user is a trail admin.
      await FirebaseFirestore.instance.collection('user_data').doc(fbUser.uid).get().then((DocumentSnapshot snapshot) {
        Map<String, dynamic> data = snapshot.data();
        setState(() {
          _isAdminUser = data['is_trail_admin'] != null ? data['is_trail_admin'] : false;
          _displayName = data['displayName'] ?? "";
          _profilePhotoUrl = data['profilePhotoUrl'] ?? ""; 
        });   
      });
    }
    // Set the preferences based on the new information
    prefs.setBool('is_trail_admin', _isAdminUser);
    prefs.setString('displayName', _displayName);
    prefs.setString('profilePhotoUrl', _profilePhotoUrl);    
  } 
}