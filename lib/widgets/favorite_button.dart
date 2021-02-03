import 'package:beer_trail_app/blocs/favorite_button_bloc.dart';
import 'package:beer_trail_app/data/trail_database.dart';
import 'package:beer_trail_app/data/trail_place.dart';
import 'package:beer_trail_app/widgets/must_check_in_dialog.dart';
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
  @override
  Widget build(BuildContext context) {
    FavoriteButtonBloc _bloc = FavoriteButtonBloc(TrailDatabase(), widget.place.id);
    // Favorite
    return StreamBuilder(
      stream: _bloc.stream,
      initialData: _bloc.isFavorite ?? false,
      builder: (context, snapshot) {
        bool isFavorite = snapshot.data;
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
                  if (_bloc.toggleFavorite()) {
                    setState(() {
                      isFavorite = !isFavorite;
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: isFavorite
                              ? Text("${widget.place.name} added to favorites")
                              : Text(
                                  "${widget.place.name} removed from favorites")));
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => 
                        MustCheckInDialog(message: "You must be signed in to select favorites.",),
                    );
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
