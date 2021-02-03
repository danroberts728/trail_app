// Copyright (c) 2020, Fermented Software.
import 'package:beer_trail_app/util/event_filter.dart';
import 'package:beer_trail_app/util/location_service.dart';
import 'package:beer_trail_app/util/trail_app_settings.dart';
import 'package:beer_trail_app/widgets/location_off_dialog.dart';
import 'package:flutter/material.dart';

/// A dropdown filter widget for events
class DropDownEventFilter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DropDownEventFilter();

  /// The event filter associated with this widget
  final EventFilter filter;

  /// Default constructor
  DropDownEventFilter({@required this.filter});
}

/// State for DropDownEventFilter
class _DropDownEventFilter extends State<DropDownEventFilter> {
  /// Filter distance selection options
  final List<double> _options = TrailAppSettings.eventFilterDistances
    ..add(double.infinity);

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
                icon: Icon(Icons.gps_not_fixed),
                isDense: true,
                iconEnabledColor: TrailAppSettings.actionLinksColor,
                iconSize: 14,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
                value: widget.filter.distance,
                onChanged: (value) {
                  widget.filter.updateFilter(distance: value);
                  if (value < double.infinity &&
                      LocationService().lastLocation == null) {
                    showDialog(
                      context: context,
                      builder: (context) => LocationOffDialog(
                        locationService: LocationService(),
                        message:
                            "It looks like we can't access your location in order to filter nearby events. Please turn on location.",
                      ),
                    );
                  }
                },
                items: _options.map((double d) {
                  return DropdownMenuItem(
                    child: d == double.infinity
                        ? Text("Any miles ")
                        : Text("${d.toStringAsFixed(0)} miles "),
                    value: d,
                  );
                }).toList(),
                selectedItemBuilder: (context) => _options.map((d) {
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
