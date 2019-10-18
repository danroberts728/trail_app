import 'package:flutter/material.dart';

class ProfilePhoto extends StatelessWidget {
  final ImageProvider image;

  ProfilePhoto({@required this.image, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3.0),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: this.image,
        ),
      ),
    );
  }
}
