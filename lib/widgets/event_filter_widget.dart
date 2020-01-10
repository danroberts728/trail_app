import 'package:alabama_beer_trail/blocs/event_filter_bloc.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventFilterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> _getRows() {
      List<Widget> retval = [
        Text(
          "Show events within: ",
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 16.0,
        )
      ];
      TrailAppSettings.eventFilterDistances.forEach((distance) {
        retval.add(FlatButton(
          onPressed: () {
            EventFilterBloc().updateFilter(distance.toDouble());
            Navigator.pop(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                EventFilterBloc().distance == distance
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                color: EventFilterBloc().distance == distance
                    ? TrailAppSettings.subHeadingColor
                    : TrailAppSettings.actionLinksColor,
                size: 20.0,
              ),
              SizedBox(
                width: 8.0,
              ),
              Text(
                "${distance.toString()} miles",
                style: TextStyle(
                  fontSize: 20.0,
                  color: EventFilterBloc().distance == distance
                      ? TrailAppSettings.subHeadingColor
                      : TrailAppSettings.actionLinksColor,
                ),
              ),
            ],
          ),
        ));
        retval.add(
          SizedBox(
            height: 4.0,
          ),
        );
      });

      retval.addAll([
        FlatButton(
          onPressed: () {
            EventFilterBloc().updateFilter(double.infinity);
            Navigator.pop(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                EventFilterBloc().distance == double.infinity
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                color: EventFilterBloc().distance == double.infinity
                    ? TrailAppSettings.subHeadingColor
                    : TrailAppSettings.actionLinksColor,
                size: 20.0,
              ),
              SizedBox(
                width: 8.0,
              ),
              Text(
                "Any miles",
                style: TextStyle(
                  fontSize: 20.0,
                  color: EventFilterBloc().distance == double.infinity
                      ? TrailAppSettings.subHeadingColor
                      : TrailAppSettings.actionLinksColor,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 4.0,
        ),
      ]);

      return retval;
    }

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _getRows(),
        ),
      ),
    );
  }
}
