// Copyright (c) 2021, Fermented Software.
import 'package:beer_trail_database/domain/trail_place.dart';
import 'package:beer_trail_app/util/app_launcher.dart';
import 'package:beer_trail_app/screens/screen_trailplace_detail/screen_trailplace_detail.dart';
import 'package:beer_trail_app/util/trail_app_settings.dart';
import 'package:beer_trail_app/widgets/favorite_button.dart';
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
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 6.0,
                shape: CircleBorder(
                  side: BorderSide(
                    color: TrailAppSettings.actionLinksColor,
                    width: 2.0,
                  ),
                ),
                padding: EdgeInsets.all(0),
              ),
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
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 6.0,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(double.infinity),
                  side: BorderSide(
                    color: TrailAppSettings.actionLinksColor,
                    width: 2.0,
                  ),
                ),
                padding: EdgeInsets.all(0),
              ),
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
          FavoriteButton(
            place: widget.place,
            iconSize: 32.0,
          ),
        ],
      ),
    );
  }
}
