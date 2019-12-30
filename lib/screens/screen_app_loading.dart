import 'dart:async';

import 'package:alabama_beer_trail/blocs/location_bloc.dart';
import 'package:flutter/material.dart';

class AppLoadingScreen extends StatefulWidget {
  State<StatefulWidget> createState() => _AppLoadingScreen();
}

class _AppLoadingScreen extends State<AppLoadingScreen> {
  StreamSubscription _authChangeSubscription;
  GlobalKey _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    LocationBloc().refreshLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/signin_bkg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/fth_black.png"),
                    fit: BoxFit.fitHeight,
                  ),
                ),
                height: 100.0,
                width: 100.0,
                child: CircularProgressIndicator(),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                "Loading...",
              ),
            ],
          ),
        ),
      ),
    );
  }

  void dispose() {
    if(_authChangeSubscription != null) {
      _authChangeSubscription.cancel();
    }    
    super.dispose();
  }
}