import 'package:alabama_beer_trail/blocs/user_data_bloc.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/data/user_data.dart';
import 'package:alabama_beer_trail/util/app_launcher.dart';
import 'package:flutter/material.dart';

class TrailPlaceActionButtonWidget extends StatefulWidget {
  final TrailPlace place;
  final Color carIconColor;
  final double iconSize;

  const TrailPlaceActionButtonWidget({Key key, @required this.place, this.carIconColor = Colors.white60, this.iconSize = 24.0}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TrailPlaceActionButtonWidget(this.place, this.carIconColor, this.iconSize);
}

class _TrailPlaceActionButtonWidget extends State<TrailPlaceActionButtonWidget> {
  final TrailPlace place;
  var userDataBloc = UserDataBloc();
  final Color carIconColor;
  final double iconSize;

  _TrailPlaceActionButtonWidget(this.place, this.carIconColor, this.iconSize);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme.bar(
      height: 50.0,
      child: ButtonBar(
        children: <Widget>[
          // Map
          SizedBox(
            width: 26.0,
            child: FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                String address =
                    '${this.place.name}, ${this.place.address}, ${this.place.city}, ${this.place.state} ${this.place.zip}';
                AppLauncher().openDirections(address);
              },
              child: Icon(
                Icons.drive_eta,
                color: carIconColor,
                size: iconSize,
              ),
            ),
          ),
          // Favorite
          SizedBox(
            width: 26.0,
            child: StreamBuilder<UserData>(
              stream: userDataBloc.userDataStream,
              builder: (context, snapshot) {
                List<String> favorites =
                    (snapshot.connectionState == ConnectionState.waiting)
                        ? List<String>.from(userDataBloc.userData.favorites)
                        : List<String>.from(snapshot.data.favorites);
                bool isFavorite =
                    favorites != null && favorites.contains(this.place.id);
                return FlatButton(
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                    size: iconSize,
                  ),
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: isFavorite
                              ? Text("${this.place.name} added to favorites")
                              : Text(
                                  "${this.place.name} removed from favorites")));
                    });
                    userDataBloc.toggleFavorite(this.place.id);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
