import 'package:alabama_beer_trail/blocs/user_data_bloc.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/util/app_launcher.dart';
import 'package:alabama_beer_trail/screens/screen_trailplace_detail/screen_trailplace_detail.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:flutter/material.dart';

class TrailPlaceActionButtonWidget extends StatefulWidget {
  final TrailPlace place;
  final Color mapIconColor;
  final Color infoIconColor;
  final double iconSize;

  const TrailPlaceActionButtonWidget(
      {Key key,
      @required this.place,
      this.mapIconColor = Colors.grey,
      this.infoIconColor = Colors.lightBlue,
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
    return ButtonBarTheme(
      data: ButtonBarThemeData(buttonHeight: 50.0),
      child: ButtonBar(
        alignment: MainAxisAlignment.end,
        children: <Widget>[
          // Info
          Container(
            width: 32.0,
            child: RaisedButton(
              elevation: 6.0,
              shape: CircleBorder(
                side: BorderSide(
                  color: TrailAppSettings.actionLinksColor,
                  width: 2.0,
                ),
              ),
              padding: EdgeInsets.all(0),
              onPressed: () {
                Feedback.forTap(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        settings: RouteSettings(
                          name: 'Trail Place - ' + widget.place.name,
                        ),
                        builder: (context) =>
                            TrailPlaceDetailScreen(place: widget.place)));
              },
              child: Icon(
                Icons.info,
                color: widget.infoIconColor,
                size: widget.iconSize,
              ),
            ),
          ),
          // Map
          Container(
            width: 32.0,
            child: RaisedButton(
              elevation: 6.0,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(double.infinity),
                side: BorderSide(
                  color: TrailAppSettings.actionLinksColor,
                  width: 2.0,
                ),
              ),
              padding: EdgeInsets.all(0),
              onPressed: () {
                String address =
                    '${widget.place.name}, ${widget.place.address}, ${widget.place.city}, ${widget.place.state} ${widget.place.zip}';
                AppLauncher().openDirections(address);
              },
              child: Icon(
                Icons.directions,
                color: widget.mapIconColor,
                size: widget.iconSize,
              ),
            ),
          ),
          // Favorite
          StreamBuilder(
            stream: userDataBloc.userDataStream,
            builder: (context, snapshot) {
              List<String> favorites =
                  (snapshot.connectionState == ConnectionState.waiting)
                      ? List<String>.from(userDataBloc.userData.favorites)
                      : List<String>.from(snapshot.data.favorites);
              bool isFavorite =
                  favorites != null && favorites.contains(widget.place.id);
              return Container(
                width: 32.0,
                child: FlatButton(
                  color: Colors.transparent,
                  padding: EdgeInsets.all(0),
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
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
