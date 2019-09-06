import 'package:flutter/material.dart';

class ProfilePhoto extends StatelessWidget {
  final NetworkImage image;

  ProfilePhoto({@required this.image, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        border: Border(),
        image: DecorationImage(
          fit: BoxFit.fitHeight,
          image: this.image,
        ),
      ),
    );
  }
}
