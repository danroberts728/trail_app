import 'package:alabama_beer_trail/data/trail_place_category.dart';
import 'package:alabama_beer_trail/util/place_filter_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ModalTrailFilter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ModalTrailFilter();
  }
}

class _ModalTrailFilter extends State<ModalTrailFilter> {
  _ModalTrailFilter();
  PlaceFilterService _placeFilterService = PlaceFilterService();
  PlaceFilter get _filter => _placeFilterService.filter;

  @override
  Widget build(BuildContext context) {
    var sortWidgets = <RadioListTile>[
      RadioListTile<SortOrder>(
        title: const Text("Name"),
        value: SortOrder.ALPHABETICAL,
        groupValue: _filter.sort,
        onChanged: (SortOrder sort) {
          setState(() => _placeFilterService.updateSort(sort));
        },
      ),
      RadioListTile<SortOrder>(
        title: const Text("Distance"),
        value: SortOrder.DISTANCE,
        groupValue: _filter.sort,
        onChanged: (SortOrder sort) {
          setState(() => _placeFilterService.updateSort(sort));
        },
      ),
    ];
    var checkboxes = List<CheckboxListTile>();
    _filter.categories.forEach((category, show) {
      checkboxes.add(
        CheckboxListTile(
            title: Text(category.plural),
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
    // Sort By
    List<Widget> list = <Widget>[
      ListTile(
        leading: Icon(FontAwesomeIcons.sortAmountDown),
        title: Text('Sort List By'),
      )
    ];
    list.addAll(sortWidgets);
    // Categories
    list.add(ListTile(
      leading: Icon(FontAwesomeIcons.filter),
      title: Text('Show Me'),
    ));
    list.add(CheckboxListTile(
      title: Text("Everything"),
      value: _filter.categories.keys.every((c) => _filter.categories[c]),
      onChanged: (bool isChecked) {
        if(isChecked) {
          setState(() {
          _placeFilterService.allCategoriesTrue();
        });
        } else {
          setState(() {
            _placeFilterService.allCategoriesFalse();
          });          
        }
      },
    ));
    list.addAll(checkboxes);

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
            child: Column(children: [
              Column(children: list),
              SizedBox(height: 16.0,),
            ],)
          ),
        ),
      ),
    );
  }
}
