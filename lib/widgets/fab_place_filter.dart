import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlaceFilterFab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlaceFilterFab();
}

class _PlaceFilterFab extends State<PlaceFilterFab>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(FontAwesomeIcons.filter),
    );
  }
}
