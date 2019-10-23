import 'package:flutter/material.dart';

import '../data/trailplace.dart';
import 'package:flutter/cupertino.dart';

class TrailPlaceScreen extends StatefulWidget {
  final TrailPlace place;

  const TrailPlaceScreen({Key key, this.place}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TrailPlaceScreen(place);
}

class _TrailPlaceScreen extends State<TrailPlaceScreen> {
  final TrailPlace place;

  _TrailPlaceScreen(this.place);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.name),
      ),
    );
  }

}