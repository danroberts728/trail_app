import 'package:alabama_beer_trail/data/trailplace.dart';
import 'package:alabama_beer_trail/widgets/traillist_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TrailListView extends StatelessWidget {
  final List<TrailPlace> places;

  TrailListView({@required this.places});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: places.length,
      itemBuilder: (BuildContext context, int index) {
        return TrailListItem(
          place: places[index],
        );
      },
    );

    
  }
}
