import 'package:alabama_beer_trail/util/event_filter_service.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:flutter/material.dart';

class EventFilterWidget extends StatelessWidget {
  final _eventFilterService = EventFilterService();

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
            _eventFilterService.updateFilter(distance: distance*1.0);
            Navigator.pop(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                _eventFilterService.filter.distance == distance * 1.0
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                color: _eventFilterService.filter.distance == distance * 1.0
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
                  color: _eventFilterService.filter.distance == distance * 1.0
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
            _eventFilterService.updateFilter(distance: double.infinity);
            Navigator.pop(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                 _eventFilterService.filter.distance == double.infinity
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                color: _eventFilterService.filter.distance == double.infinity
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
                  color: _eventFilterService.filter.distance == double.infinity
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
