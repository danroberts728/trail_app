import 'package:beer_trail_app/util/filteroptions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModalTrailFilter extends StatefulWidget {
  final FilterOptions initialOptions;

  ModalTrailFilter({@required this.initialOptions});

  @override
  State<StatefulWidget> createState() =>
      _ModalTrailFilter(options: this.initialOptions);
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
    var checkboxes = List<Widget>();
    options.show.forEach((filter, show) {
      checkboxes.add(
        CheckboxListTile(
            title: Text(filter),
            value: show,
            onChanged: (bool newValue) {
              setState(() {
                Map<String, bool> newFilters = options.show;
                newFilters[filter] = !show;
                options = FilterOptions(options.sort, newFilters);
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
      title: Text('Show Only'),
    ));
    list.addAll(checkboxes);
    list.add(
      RaisedButton(
        onPressed: () => Navigator.pop(context, this.options),
        child: Text("Update"),
      ),
    );
    return SingleChildScrollView(
      child: Column(children: list),
    );
  }
}
