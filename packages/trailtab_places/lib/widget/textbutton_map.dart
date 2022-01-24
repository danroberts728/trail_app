import 'dart:io';

import 'package:flutter/material.dart';
import 'package:trail_database/domain/trail_place.dart';
import 'package:url_launcher/url_launcher.dart';

class TextButtonMap extends StatelessWidget {
  final TrailPlace place;

  const TextButtonMap({Key key, @required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        "MAP",
        style: TextStyle(
          color: Theme.of(context).textTheme.button.color,
        ),
      ),
      onPressed: () async {
        String address =
            '${place.name}, ${place.address}, ${place.city}, ${place.state} ${place.zip}';
        // Android
        var url = 'geo:0,0?q=$address';
        if (Platform.isIOS) {
          // iOS
          address = address.replaceAll(' ', '+');
          url = 'https://maps.apple.com/?q=$address';
        }

        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      },
    );
  }
}
