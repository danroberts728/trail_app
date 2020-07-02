import '../util/filter_options.dart';
import '../data/trail_place_category.dart';
import 'package:flutter/material.dart';

class ModalTrailFilter extends StatefulWidget {
  final FilterOptions initialOptions;

  ModalTrailFilter({@required this.initialOptions});

  @override
  State<StatefulWidget> createState() {
    return _ModalTrailFilter(options: this.initialOptions);
  }
}

class _ModalTrailFilter extends State<ModalTrailFilter> {
  FilterOptions options;

  _ModalTrailFilter({@required this.options});

  @override
  Widget build(BuildContext context) {
    var sortWidgets = <RadioListTile>[
      RadioListTile<SortOrder>(
        title: const Text("Name"),
        value: SortOrder.ALPHABETICAL,
        groupValue: options.sort,
        onChanged: (SortOrder sort) {
          setState(() => options = FilterOptions(sort, options.show));
        },
      ),
      RadioListTile<SortOrder>(
        title: const Text("Distance"),
        value: SortOrder.DISTANCE,
        groupValue: options.sort,
        onChanged: (SortOrder sort) {
          setState(() => options = FilterOptions(sort, options.show));
        },
      ),
    ];
    var checkboxes = List<CheckboxListTile>();
    options.show.forEach((filter, show) {
      checkboxes.add(
        CheckboxListTile(
            title: Text(filter.plural),
            value: show,
            onChanged: (bool newValue) {
              setState(() {
                Map<TrailPlaceCategory, bool> newFilters = this.options.show;
                newFilters[filter] = !show;
                this.options = FilterOptions(this.options.sort, newFilters);
              });
            }),
      );
    });
    List<Widget> list = <Widget>[
      ListTile(
        leading: Icon(Icons.sort),
        title: Text('Sort By'),
      )
    ];
    list.addAll(sortWidgets);
    list.add(ListTile(
      leading: Icon(Icons.sort),
      title: Text('Show Me'),
    ));
    list.add(CheckboxListTile(
      title: Text("Everything"),
      value: this.options.show.values.where((a) => a).length ==
          options.show.length,
      onChanged: (bool isChecked) {
        setState(() {
          options.show.updateAll((f, v) => v = isChecked);
        });
      },
    ));
    list.addAll(checkboxes);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, this.options);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          title: Text("Filter"),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(children: list),
          ),
        ),
      ),
    );
  }
}
