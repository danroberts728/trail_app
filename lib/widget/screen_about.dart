// Copyright (c) 2020, Fermented Software.
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// The About screen.
class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(32.0),
            child: Column(
              children: <Widget>[
                Image(
                  height: 100.0,
                  image: AssetImage(
                    'assets/images/fth_black.png',
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                RichText(
                  textAlign: TextAlign.justify,
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
                        text: ". Founded in 2004, Free the Hops is a grassroots organization formed " +
                            "to help bring the highest quality beers in the world to Alabama.",
                      ),
                      TextSpan(text: "\n\n"),
                      TextSpan(
                        text: "We have passed significant legislation, including the Gourmet Beer Bill " +
                            "that legalized beer with an alcohol by volume (ABV) of more than 6% and the " +
                            "Brewery Modernization Act that legalized brewery and distillery tasting rooms. " +
                            "We also supported the legalization of homebrewing and serve as a watchdog for " +
                            "craft beer consumers at the State House.",
                      ),
                      TextSpan(
                        text: "\n\n",
                      ),
                      TextSpan(
                        text: "We have hosted the Magic City Brewfest in Birmingham since 2007 and the Rocket " +
                            "City Brewfest in Huntsville since 2009. These two festivals are the premier craft " +
                            "beer events in Alabama.",
                      ),
                      TextSpan(
                        text: "\n\n",
                      ),
                      TextSpan(
                        text: "Since late 2019, Free the Hops is a program of Alabama Brewers Guild. The " +
                            "management is led by a Governing Committee of dedicated consumer volunteers.",
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        child: Icon(
                          FontAwesomeIcons.facebook,
                          color: Color(0xff3b5998),
                        ),
                        onTap: () => _openFacebookPage(
                          '178685318846986',
                        ),
                      ),
                      InkWell(
                        child: Icon(FontAwesomeIcons.twitter,
                            color: Color(0xff1da1f2)),
                        onTap: () => launch(
                          'https://twitter.com/freethehops',
                        ),
                      ),
                      InkWell(
                        child: Icon(FontAwesomeIcons.instagram,
                            color: Color(0xffc13584)),
                        onTap: () => launch(
                          'https://www.instagram.com/freethehops/',
                        ),
                      ),
                      InkWell(
                        child:
                            Icon(FontAwesomeIcons.link, color: Colors.blueGrey),
                        onTap: () => launch(
                          'https://freethehops.org',
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey,
                ),
                Text("Developed by Fermented Software"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void _openFacebookPage(String pageId) async {
    String fbProtocolUrl;
    String fallbackUrl = "https://www.facebook.com/$pageId";
    if (Platform.isAndroid) {
      fbProtocolUrl = "fb://page/$pageId";
    } else if (Platform.isIOS) {
      fbProtocolUrl = "fb://profile/$pageId";
    } else {
      fbProtocolUrl = fallbackUrl;
    }
    try {
      canLaunch(fbProtocolUrl).then((bool yes) {
        if (yes) {
          launch(fbProtocolUrl);
        } else {
          launch(fallbackUrl);
        }
      });
    } catch (e) {
      await launch(fallbackUrl);
    }
  }
}
