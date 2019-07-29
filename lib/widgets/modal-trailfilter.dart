import 'package:beer_trail_app/util/filteroptions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModalTrailFilter extends StatefulWidget {
  final FilterOptions initialOptions;

  ModalTrailFilter({@required this.initialOptions});

  @override
  State<StatefulWidget> createState() => _ModalTrailFilter(options: this.initialOptions);
}

class _ModalTrailFilter extends State<ModalTrailFilter> {
  FilterOptions options;

  _ModalTrailFilter({@required this.options});

  @override
  Widget build(BuildContext context) {
    return Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.sort),
              title: Text('Sort'),
            ),
            RadioListTile<SortOrder>(
              title: const Text("Sort by Name"),
              value: SortOrder.ALPHABETICAL,
              groupValue: options.sort,
              onChanged: (SortOrder sort) { setState(() => options = FilterOptions(sort) ); },
            ),
            RadioListTile<SortOrder>(
              title: const Text("Sort by Distance"),
              value: SortOrder.DISTANCE,
              groupValue: options.sort,
              onChanged: (SortOrder sort) { setState(() => options = FilterOptions(sort) ); },
            ),
            RaisedButton(
              onPressed: () => Navigator.pop(context, this.options),
              child: Text("Update"),

            )
          ],
        );
  }
}
