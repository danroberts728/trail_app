import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: Container(
        padding: EdgeInsets.all(32.0),
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
              height: 1.2,
            ),
            children: [
              TextSpan(
                text: "The Alabama Beer Trail is brought to you by ",
              ),
              TextSpan(
                text: "Free the Hops",
                style: TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launch("https://freethehops.org");
                  },
              ),
              TextSpan(
                text: ". "
              )
            ],
          ),
        ),
      ),
    );
  }
}
