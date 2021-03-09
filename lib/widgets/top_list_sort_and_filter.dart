import 'package:trail_location_service/trail_location_service.dart';
import 'package:beer_trail_app/util/place_filter.dart';
import 'package:beer_trail_app/util/trail_app_settings.dart';
import 'package:flutter/material.dart';

class TopListSortAndFilter extends StatefulWidget {
  final PlaceFilter filter;
  TopListSortAndFilter(this.filter);

  @override
  State<StatefulWidget> createState() => _TopListSortAndFiltert();
}

class _TopListSortAndFiltert extends State<TopListSortAndFilter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Wrap(
        // Keeping this here so it's extensible
        alignment: WrapAlignment.start,
        direction: Axis.horizontal,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 4.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white54,
              ),
              child: DropdownButton(
                underline: SizedBox(),
                icon: Icon(Icons.sort),
                isDense: true,
                iconEnabledColor: TrailAppSettings.actionLinksColor,
                iconSize: 14,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
                value: widget.filter.filterCriteria.sort,
                onChanged: (value) {
                  widget.filter.updateSort(value);
                  Future.delayed(Duration(seconds: 2), () {
                    if (value == SortOrder.DISTANCE &&
                        TrailLocationService().lastLocation == null) {
                      showDialog(
                        context: context,
                        builder: (context) => LocationOffDialog(
                            locationService: TrailLocationService(),
                            message:
                                "You must allow location permissions to sort by distance"),
                      );
                    }
                  });
                },
                items: [
                  DropdownMenuItem(
                    child: Text("Alphabetical "),
                    value: SortOrder.ALPHABETICAL,
                  ),
                  DropdownMenuItem(
                    child: Text("Distance "),
                    value: SortOrder.DISTANCE,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 4.0,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 4.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white54,
              ),
              child: DropdownButton(
                underline: SizedBox(),
                icon: Icon(Icons.access_time),
                isDense: true,
                iconEnabledColor: TrailAppSettings.actionLinksColor,
                iconSize: 14,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
                value: widget.filter.filterCriteria.hoursOption,
                onChanged: (value) => widget.filter.updateHoursOption(value),
                items: [
                  DropdownMenuItem(
                      child: Text("Any Hours "), value: HoursOption.ALL),
                  DropdownMenuItem(
                    child: Text("Open Now "),
                    value: HoursOption.OPEN_NOW,
                  ),
                  DropdownMenuItem(
                    child: Text("Open Today "),
                    value: HoursOption.OPEN_TODAY,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
