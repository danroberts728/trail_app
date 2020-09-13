import 'package:alabama_beer_trail/util/event_filter_service.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:flutter/material.dart';

class TopEventFilter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TopEventFilter();
}

class _TopEventFilter extends State<TopEventFilter> {
  final List<double> _options = [5, 25, 50, 100, double.infinity];

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
                icon: Icon(Icons.gps_not_fixed),
                isDense: true,
                iconEnabledColor: TrailAppSettings.actionLinksColor,
                iconSize: 14,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
                value: EventFilterService().filter.distance,
                onChanged: (value) => EventFilterService().updateFilter(distance: value),
                items: _options.map((double d) {
                    return DropdownMenuItem(
                      child: d == double.infinity
                        ? Text("Any miles ")
                        : Text("${d.toStringAsFixed(0)} miles "),
                      value: d,
                    );
                  }).toList(),
                selectedItemBuilder: (context) => 
                  _options.map((d) {
                    return d == double.infinity
                      ? Text("All events ")
                      : Text("Events within ${d.toStringAsFixed(0)} miles ");
                  }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
