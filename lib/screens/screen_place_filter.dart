import 'dart:async';

import 'package:alabama_beer_trail/data/trail_place_category.dart';
import 'package:alabama_beer_trail/util/place_filter_service.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ModalTrailFilter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ModalTrailFilter();
  }
}

class _ModalTrailFilter extends State<ModalTrailFilter> {
  StreamSubscription _placeFilterStreamSubscription;

  _ModalTrailFilter() {
    _placeFilterStreamSubscription = _placeFilterService.stream.listen((event) {
      setState(() {});
    });
  }
  PlaceFilterService _placeFilterService = PlaceFilterService();
  PlaceFilter get _filter => _placeFilterService.filter;

  @override
  Widget build(BuildContext context) {
    var swtiches = List<Widget>();
    _filter.categories.forEach((category, show) {
      swtiches.add(
        SwitchListTile(
            title: Row(
              children: [
                Text(category.plural),
                Visibility(
                  visible: category.description.isNotEmpty,
                  child: IconButton(
                    icon: Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                    ),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(category.description),
                                FlatButton(
                                  child: Text(
                                    "Dismiss",
                                    style: TextStyle(
                                      color: TrailAppSettings.actionLinksColor,
                                    ),
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            activeColor: TrailAppSettings.actionLinksColor,
            value: show,
            onChanged: (bool newValue) {
              setState(() {
                Map<TrailPlaceCategory, bool> newFilters = _filter.categories;
                newFilters[category] = !show;
                _placeFilterService.updateCategories(newFilters);
              });
            }),
      );
    });
    List<Widget> list = List<Widget>();
    // Hours
    list.add(
      ListTile(
        visualDensity: VisualDensity.compact,
        leading: Icon(
          FontAwesomeIcons.clock,
          color: TrailAppSettings.subHeadingColor,
        ),
        title: Text('HOURS',
            style: TextStyle(
                color: TrailAppSettings.subHeadingColor,
                fontWeight: FontWeight.bold)),
      ),
    );
    list.add(
      Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed: () =>
                  PlaceFilterService().updateHoursOption(HoursOption.ALL),
              color: PlaceFilterService().filter.hoursOption == HoursOption.ALL
                  ? TrailAppSettings.subHeadingColor
                  : Colors.white60,
              child: Text(
                "Any Time",
                style: TextStyle(
                    color: PlaceFilterService().filter.hoursOption ==
                            HoursOption.ALL
                        ? Colors.white
                        : TrailAppSettings.actionLinksColor),
              ),
            ),
            FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: PlaceFilterService().filter.hoursOption ==
                      HoursOption.OPEN_TODAY
                  ? TrailAppSettings.subHeadingColor
                  : Colors.white60,
              onPressed: () => PlaceFilterService()
                  .updateHoursOption(HoursOption.OPEN_TODAY),
              child: Text(
                "Open Today",
                style: TextStyle(
                    color: PlaceFilterService().filter.hoursOption ==
                            HoursOption.OPEN_TODAY
                        ? Colors.white
                        : TrailAppSettings.actionLinksColor),
              ),
            ),
            FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: PlaceFilterService().filter.hoursOption ==
                      HoursOption.OPEN_NOW
                  ? TrailAppSettings.subHeadingColor
                  : Colors.white60,
              onPressed: () =>
                  PlaceFilterService().updateHoursOption(HoursOption.OPEN_NOW),
              child: Text(
                "Open Now",
                style: TextStyle(
                    color: PlaceFilterService().filter.hoursOption ==
                            HoursOption.OPEN_NOW
                        ? Colors.white
                        : TrailAppSettings.actionLinksColor),
              ),
            ),
          ],
        ),
      ),
    );
    // Categories
    list.add(ListTile(
      visualDensity: VisualDensity.compact,
      leading: Icon(
        FontAwesomeIcons.filter,
        color: TrailAppSettings.subHeadingColor,
      ),
      title: Text('SHOW ME',
          style: TextStyle(
              color: TrailAppSettings.subHeadingColor,
              fontWeight: FontWeight.bold)),
    ));
    list.add(
      SwitchListTile(
        title: Row(
          children: <Widget>[
            Text("Everything"),
          ],
        ),
        activeColor: TrailAppSettings.actionLinksColor,
        value: _filter.categories.keys.every((c) => _filter.categories[c]),
        onChanged: (bool isChecked) {
          if (isChecked) {
            setState(() {
              _placeFilterService.allCategoriesTrue();
            });
          } else {
            setState(() {
              _placeFilterService.allCategoriesFalse();
            });
          }
        },
      ),
    );
    list.addAll(swtiches);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _placeFilterService);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          title: Text("Filter"),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(children: list),
                SizedBox(
                  height: 16.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _placeFilterStreamSubscription.cancel();
    super.dispose();
  }
}
