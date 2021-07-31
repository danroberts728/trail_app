import 'package:beer_trail_admin/common_widgets/edit_form_box.dart';
import 'package:beer_trail_admin/screens/trail_places/trail_place_edit_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trail_database/trail_database.dart';

const allowedCategories = <String>[
  "Brewery",
  "Distillery",
  "Winerey",
  "Tasting Room",
  "Open Bar",
  "Restaurant"
];

class TrailPlaceEdit extends StatefulWidget {
  final TrailPlace place;

  const TrailPlaceEdit({Key key, this.place}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _TrailPlaceEdit();
}

class _TrailPlaceEdit extends State<TrailPlaceEdit> {
  TrailPlaceEditBloc _bloc;

  @override
  void initState() {
    _bloc = TrailPlaceEditBloc(placeId: widget.place.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.place.name),
      ),
      body: StreamBuilder(
        initialData: _bloc.editablePlace,
        stream: _bloc.stream,
        builder: (context, snapshot) {
          TempPlace place = snapshot.data;
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EditFormBox(
                      width: constraints.maxWidth * 3 / 4 - 12,
                      title: "Name and Categories",
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Place Name",
                          ),
                          initialValue: _bloc.editablePlace.name,
                          onChanged: (n) => _bloc.editablePlace.name = n,
                        ),
                        Wrap(
                          children: allowedCategories
                              .map(
                                (c) => SwitchListTile(
                                  dense: true,
                                  title: Text(c),
                                  value: _bloc.editablePlace.categories.contains(c),
                                  onChanged: (yes) {
                                    if (yes) {
                                      setState(() {
                                        _bloc.addCategory(c);
                                      });
                                    } else {
                                      setState(() {
                                        _bloc.removeCategory(c);
                                      });
                                    }
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                    EditFormBox(
                      title: "Save & Publish",
                      width: constraints.maxWidth * 1 / 4 - 12,
                      children: [
                        SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.visibility),
                            SizedBox(width: 8.0),
                            Text("Status:"),
                            SizedBox(width: 8.0),
                            Text( _bloc.editablePlace.published ?
                              "Published" : "Draft",
                            ),
                            Spacer(),
                            Switch(
                              value: _bloc.editablePlace.published,
                              onChanged: (value) => _bloc.changePublishStatus(value),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
