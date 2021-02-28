// Copyright (c) 2021, Fermented Software.
import 'package:beer_trail_app/model/trail_news_post.dart';
import 'package:beer_trail_app/screens/screen_trailnews_post.dart';
import 'package:beer_trail_app/util/trail_app_settings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webfeed/domain/rss_item.dart';

class TrailNewsItem extends StatelessWidget {
  final RssItem _item;

  TrailNewsItem(this._item);

  @override
  Widget build(BuildContext context) {
    TrailNewsPost post = TrailNewsPost.fromRssItem(_item);

    return InkWell(
      onTap: () {
        Feedback.forTap(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                settings: RouteSettings(
                  name: '/news/${post.id}',
                ),
                builder: (context) => ScreenTrailNewsPost(post: post)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
        color: Colors.grey[100],
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          elevation: 4.0,
          child: Container(
            height: 150.0,
            child: Row(
              children: <Widget>[
                Image(
                  image:
                      post.imageThumbnail,
                  width: 150.0,
                  height: 150.0,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 8.0),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(post.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18.0,
                              color: TrailAppSettings.first,
                              fontWeight: FontWeight.bold,
                              fontFamily: "VT323")),
                      SizedBox(
                        height: 8.0,
                      ),
                      // Excerpt
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text(
                          removeAllHtmlTags(post.description),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      // Date and Author
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.calendar_today,
                            color: TrailAppSettings.subHeadingColor,
                            size: 12.0,
                          ),
                          SizedBox(
                            width: 2.0,
                          ),
                          Text(
                            DateFormat("MMM d y").format(post.publicationDateTime),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: TrailAppSettings.subHeadingColor,
                                fontSize: 12.0),
                          ),
                          SizedBox(
                            width: 6.0,
                          ),
                          Icon(
                            Icons.person,
                            color: TrailAppSettings.subHeadingColor,
                            size: 12.0,
                          ),
                          SizedBox(
                            width: 2.0,
                          ),
                          Expanded(
                            child: Text(
                              post.creator.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: TrailAppSettings.subHeadingColor,
                                  fontSize: 12.0),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }
}
