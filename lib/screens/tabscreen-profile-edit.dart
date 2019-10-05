import 'package:alabama_beer_trail/util/appauth.dart';
import 'package:alabama_beer_trail/util/const.dart';
import 'package:alabama_beer_trail/widgets/profile-photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditProfileScreen extends StatefulWidget {
  final String userId;

  EditProfileScreen({@required this.userId});

  @override
  State<StatefulWidget> createState() => _EditProfileScreen(this.userId);
}

class _EditProfileScreen extends State<EditProfileScreen> {
  final String userId;

  _EditProfileScreen(this.userId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.save),
            color: Colors.white,
          ),
        ],
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: 166.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/fthglasses.jpg"),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  Colors.grey.shade700, BlendMode.darken),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50.0,
                        )
                      ],
                    ),
                    Positioned(
                      bottom: 66.0,
                      right: 16.0,
                      child: FloatingActionButton(
                        elevation: 16.0,
                        backgroundColor: Constants.colors.second.withAlpha(125),
                        child: Icon(Icons.add_a_photo),
                        onPressed: () {},
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 16.0,
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          ProfilePhoto(
                            image: NetworkImage(AppAuth().user.defaultProfilePhotoUrl),
                          ),
                          FloatingActionButton(
                            elevation: 16.0,
                            backgroundColor: Colors.transparent,
                            child: Icon(Icons.add_a_photo),
                            onPressed: () {},
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
