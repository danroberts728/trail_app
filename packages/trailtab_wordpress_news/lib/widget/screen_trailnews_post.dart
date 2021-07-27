// Copyright (c) 2020, Fermented Software.
import 'package:trailtab_wordpress_news/model/trail_news_post.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart' as intl;

/// The News post screen with Scaffold
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
            onPressed: () => launch(post.link),
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
                  key: ValueKey("ScreenTrailNewsPostThumbnail-${post.id}"),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Title
                    Text(
                      post.title,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.headline1,
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
                            color: Theme.of(context).textTheme.subtitle1.color,
                            size: Theme.of(context).textTheme.subtitle1.fontSize + 2,
                          ),
                          SizedBox(
                            width: 2.0,
                          ),
                          Text(
                            intl.DateFormat("MMM d y")
                                .format(post.publicationDateTime),
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.subtitle1
                          ),
                          SizedBox(
                            width: 6.0,
                          ),
                          Icon(
                            Icons.person,
                            color: Theme.of(context).textTheme.subtitle1.color,
                            size: Theme.of(context).textTheme.subtitle1.fontSize + 2,
                          ),
                          SizedBox(
                            width: 2.0,
                          ),
                          Text(
                            post.creator.toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    HtmlWidget(
                      post.content,
                      onTapUrl: (url) => launch(url),
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
