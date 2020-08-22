import 'package:alabama_beer_trail/blocs/user_data_bloc.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:flutter/material.dart';

class FavoriteButton extends StatefulWidget {
  final TrailPlace place;
  final double iconSize;

  const FavoriteButton({Key key, @required this.place, this.iconSize})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _FavoriteButton();
}

class _FavoriteButton extends State<FavoriteButton> {
  UserDataBloc userDataBloc = UserDataBloc();

  @override
  Widget build(BuildContext context) {
    // Favorite
    return StreamBuilder(
      stream: userDataBloc.userDataStream,
      builder: (context, snapshot) {
        List<String> favorites =
            (snapshot.connectionState == ConnectionState.waiting)
                ? List<String>.from(userDataBloc.userData.favorites)
                : List<String>.from(snapshot.data.favorites);
        bool isFavorite =
            favorites != null && favorites.contains(widget.place.id);
        return Stack(        
          alignment: Alignment.center,  
          children: <Widget>[
            Container(
              width: widget.iconSize + 4,
              height: widget.iconSize + 4,
              child: Icon(
                Icons.favorite_border,
                color: Colors.grey,
                size: widget.iconSize + 2,
              ),
            ),
            Container(
              width: widget.iconSize,
              height: widget.iconSize,
              child: FlatButton(
                shape: CircleBorder(),
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
            ),
          ],
        );
      },
    );
  }
}
