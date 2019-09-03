import 'package:flutter/material.dart';

import '../data/trailplace.dart';
import 'package:flutter/cupertino.dart';

class TrailPlaceDetail extends StatefulWidget {
  final TrailPlace place;

  const TrailPlaceDetail({Key key, this.place}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TrailPlaceDetail(place);
}

class _TrailPlaceDetail extends State<TrailPlaceDetail> {
  final TrailPlace place;

  _TrailPlaceDetail(this.place);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.name),
      ),
    );
  }

}