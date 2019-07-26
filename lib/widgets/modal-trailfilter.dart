import 'package:beer_trail_app/util/filteroptions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModalTrailFilter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ModalTrailFilter();
}

class _ModalTrailFilter extends State<ModalTrailFilter> {
  SortOrder sortOrder;

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
              groupValue: sortOrder,
              onChanged: null,
            ),
            RadioListTile<SortOrder>(
              title: const Text("Sort by Distance"),
              value: SortOrder.DISTANCE,
              groupValue: sortOrder,
              onChanged: null,
            ),
          ],
        );
  }
}
