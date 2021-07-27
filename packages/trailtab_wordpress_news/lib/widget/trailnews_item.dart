// Copyright (c) 2021, Fermented Software.
import 'package:trailtab_wordpress_news/model/trail_news_post.dart';
import 'package:trailtab_wordpress_news/widget/screen_trailnews_post.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webfeed/domain/rss_item.dart';

/// A news item for the tab list
class TrailNewsItem extends StatelessWidget {
  final RssItem item;

  TrailNewsItem({@required this.item});

  @override
  Widget build(BuildContext context) {
    TrailNewsPost post = TrailNewsPost.createPostFromRssItem(item);

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
            height: 150,
            child: Row(
              children: <Widget>[
                Image(
                  key: ValueKey("TrailnewsThumbnail-${post.id}"),
                  image: post.imageThumbnail,
                  width: 150.0,
                  height: 150.0,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 8.0),
                Flexible(
                  fit: FlexFit.loose,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 6.0,
                      ),
                      Text(
                        post.title,
                        key: ValueKey("TrailNewsTitle-${post.id}"),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      SizedBox(
                        height: 6.0,
                      ),
                      // Excerpt
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          removeAllHtmlTags(post.description),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ),
                      SizedBox(
                        height: 6.0,
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Container(
                          child:
                              // Date and Author
                              Row(
                            children: <Widget>[
                              Icon(
                                Icons.calendar_today,
                                size: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .fontSize +
                                    2,
                                color:
                                    Theme.of(context).textTheme.subtitle2.color,
                              ),
                              SizedBox(
                                width: 2.0,
                              ),
                              Text(
                                DateFormat("MMM d y")
                                    .format(post.publicationDateTime),
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                              SizedBox(
                                width: 6.0,
                              ),
                              Icon(
                                Icons.person,
                                size: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .fontSize +
                                    2,
                                color:
                                    Theme.of(context).textTheme.subtitle2.color,
                              ),
                              SizedBox(
                                width: 2.0,
                              ),
                              Expanded(
                                child: Text(
                                  post.creator.toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                              ),
                            ],
                          ),
                        ),
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
