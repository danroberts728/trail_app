// Copyright (c) 2020, Fermented Software.
import 'package:flutter/material.dart';

/// A statistic for the app, designed for use in the app's drawer
class ProfileStat extends StatelessWidget {
  final String postText;
  final int value;
  final Function onPressed;

  ProfileStat(
      {@required this.postText,
      @required this.value,
      @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onPressed,
      child: RichText(
        text: TextSpan(
          text: this.value.toString() ?? '-',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            height: 1.5,
            fontSize: 18.0,
          ),
          children: <TextSpan> [
            TextSpan(
              text: " ${this.postText}",
              style: TextStyle(
                color: Theme.of(context).buttonColor,
                fontWeight: FontWeight.normal,
                fontSize: 18.0,
                height: 1.5,
              ),
            ),
          ]
        ),
      ),
    );
  }
}
