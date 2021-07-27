// Copyright (c) 2020, Fermented Software.
import 'package:trailtab_places/bloc/stamped_place_icon_bloc.dart';
import 'package:trail_database/domain/trail_place.dart';

import 'package:flutter/material.dart';
import 'package:flutter_circular_text/circular_text/model.dart';
import 'package:flutter_circular_text/circular_text/widget.dart';
import 'package:intl/intl.dart';

class StampedPlaceIcon extends StatelessWidget {
  final TrailPlace place;
  final DateTime firstCheckIn;
  final int count;
  final double diameter;
  final double tilt;
  final Color color;
  final Color backgroundColor;
  final double dateFontSize;
  final double nameFontSize;
  final double cityFontSize;
  final double bottomDateMargin;
  final double padding;

  StampedPlaceIcon({
    @required this.place,
    @required this.firstCheckIn,
    @required this.count,
    this.diameter = 75,
    this.tilt = 0,
    this.backgroundColor = Colors.white60,
    this.dateFontSize = 7.0,
    this.nameFontSize = 24.0,
    this.cityFontSize = 20.0,
    this.bottomDateMargin = 24.0,
    this.padding = 8,
    @required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
        turns: AlwaysStoppedAnimation(tilt / 360),
        child: Center(
          child: Stack(
            children: [
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                    image: AssetImage('assets/images/stamp_outline.png'),
                  ),
                  shape: BoxShape.circle,
                ),
                margin: EdgeInsets.only(right: 4.0),
                height: diameter,
                width: diameter,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: backgroundColor,
                  ),
                  height: diameter - padding,
                  width: diameter - padding,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularText(
                        radius: 100,
                        position: CircularTextPosition.inside,
                        children: [
                          TextItem(
                            text: Text(
                              place.name.length <= 25
                                  ? place.name
                                  : StampedPlaceIconBloc.getShortText(
                                      place.name, 25),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: nameFontSize),
                            ),
                            space: 8,
                            startAngle: -90,
                            startAngleAlignment: StartAngleAlignment.center,
                            direction: CircularTextDirection.clockwise,
                          ),
                          TextItem(
                            text: Text(
                              place.city.length <= 12
                                  ? place.city.toUpperCase()
                                  : StampedPlaceIconBloc.getShortText(
                                      place.city, 12).toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: cityFontSize),
                            ),
                            space: 8,
                            startAngle: 90,
                            startAngleAlignment: StartAngleAlignment.center,
                            direction: CircularTextDirection.anticlockwise,
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: bottomDateMargin,
                        child: Text(
                          DateFormat("dd MMM ''yy").format(firstCheckIn).toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: dateFontSize),
                        ),
                      ),
                      Positioned(
                        bottom: bottomDateMargin + dateFontSize + 1,
                        child: Text(
                          "Stamped".toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: dateFontSize - 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: count > 1,
                child: Positioned(
                  right: 1,
                  bottom: 1,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withAlpha(200),
                    ),
                    child: Text(
                      count.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
