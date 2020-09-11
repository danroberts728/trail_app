import 'package:alabama_beer_trail/util/place_filter_service.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:flutter/material.dart';

class TopListSort extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TopListSort();
}

class _TopListSort extends State<TopListSort> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Wrap(  // Keeping this here so it's extensible
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
                value: PlaceFilterService().filter.sort,
                onChanged: (value) => PlaceFilterService().updateSort(value),
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
          
        ],
      ),
    );
  }
}
