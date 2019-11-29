import 'package:alabama_beer_trail/blocs/user_data_bloc.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/data/user_data.dart';
import 'package:alabama_beer_trail/util/app_launcher.dart';
import 'package:flutter/material.dart';

class TrailPlaceActionButtonWidget extends StatefulWidget {
  final TrailPlace place;
  final Color carIconColor;
  final double iconSize;

  const TrailPlaceActionButtonWidget(
      {Key key,
      @required this.place,
      this.carIconColor = Colors.lightBlue,
      this.iconSize = 32.0})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TrailPlaceActionButtonWidget();
}

class _TrailPlaceActionButtonWidget
    extends State<TrailPlaceActionButtonWidget> {
  var userDataBloc = UserDataBloc();

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
                    '${widget.place.name}, ${widget.place.address}, ${widget.place.city}, ${widget.place.state} ${widget.place.zip}';
                AppLauncher().openDirections(address);
              },
              child: Icon(
                Icons.directions,
                color: widget.carIconColor,
                size: widget.iconSize,
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
                    favorites != null && favorites.contains(widget.place.id);
                return FlatButton(
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                    size: widget.iconSize,
                  ),
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: isFavorite
                              ? Text("${widget.place.name} added to favorites")
                              : Text(
                                  "${widget.place.name} removed from favorites")));
                    });
                    userDataBloc.toggleFavorite(widget.place.id);
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
