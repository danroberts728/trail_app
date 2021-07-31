import 'package:flutter/material.dart';

class TrailAdminScreen extends StatelessWidget {
  final String title;
  final Widget body;

  const TrailAdminScreen({Key key, @required this.title, @required this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 4.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headline3),
            body,
          ],
        ),
      ),
    );
  }
}
