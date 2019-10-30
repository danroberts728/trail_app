import 'package:alabama_beer_trail/data/trailplace.dart';
import 'package:alabama_beer_trail/widgets/trailplace_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TrailListView extends StatelessWidget {
  final List<TrailPlace> places;

  TrailListView({@required this.places});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10.0),
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: places.length,
          itemBuilder: (BuildContext context, int index) {
            if (places.length < 1) {
              return Center(child: Text("Nothing to show"));
            } else {
              return TrailListCard(
                place: places[index],
              );
            }
          },
        ));
  }
}
