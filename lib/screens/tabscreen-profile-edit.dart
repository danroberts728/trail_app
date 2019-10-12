import 'package:alabama_beer_trail/blocs/user_data_bloc.dart';
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

  UserDataBloc _userDataBloc = UserDataBloc();

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
      body: StreamBuilder(
        stream: this._userDataBloc.userDataStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return Container(
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
                                    image:
                                        snapshot.data['bannerImageUrl'] != null
                                            ? NetworkImage(
                                                snapshot.data['bannerImageUrl'])
                                            : AssetImage(
                                                'assets/images/fthglasses.jpg'),
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
                              heroTag: 'btn1',
                              elevation: 16.0,
                              backgroundColor:
                                  Constants.colors.second.withAlpha(125),
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
                                  image: snapshot.data['profilePhotoUrl'] !=
                                          null
                                      ? NetworkImage(
                                          snapshot.data['profilePhotoUrl'])
                                      : AssetImage(
                                          'assets/images/defaultprofilephoto.png'),
                                ),
                                FloatingActionButton(
                                  heroTag: 'btn2',
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
            );
          }
        },
      ),
    );
  }
}
