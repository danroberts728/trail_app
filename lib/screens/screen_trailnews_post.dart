import 'package:alabama_beer_trail/data/trail_news_post.dart';
import 'package:alabama_beer_trail/util/app_launcher.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart' as intl;

class ScreenTrailNewsPost extends StatelessWidget {
  final TrailNewsPost post;

  const ScreenTrailNewsPost({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => AppLauncher().openWebsite(post.link),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                child: Image(
                  image: post.imageThumbnail,
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              ),
              Container(
                margin: EdgeInsets.all(16.0),
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    // Title
                    Text(
                      post.title,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 22.0,
                          color: TrailAppSettings.first,
                          fontWeight: FontWeight.bold,
                          fontFamily: "VT323"),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    // Date and Author
                    Container(
                      width: double.infinity,
                      child: Wrap(
                        runAlignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        alignment: WrapAlignment.start,
                        direction: Axis.horizontal,
                        textDirection: TextDirection.ltr,
                        children: <Widget>[
                          Icon(
                            Icons.calendar_today,
                            color: TrailAppSettings.subHeadingColor,
                            size: 18.0,
                          ),
                          SizedBox(
                            width: 2.0,
                          ),
                          Text(
                            intl.DateFormat("MMM d y")
                                .format(post.publicationDateTime),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: TrailAppSettings.subHeadingColor,
                                fontSize: 14.0),
                          ),
                          SizedBox(
                            width: 6.0,
                          ),
                          Icon(
                            Icons.person,
                            color: TrailAppSettings.subHeadingColor,
                            size: 18.0,
                          ),
                          SizedBox(
                            width: 2.0,
                          ),
                          Text(
                            post.creator.toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: TrailAppSettings.subHeadingColor,
                                fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    HtmlWidget(
                      post.content,
                      onTapUrl: (url) => AppLauncher().openWebsite(url),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
