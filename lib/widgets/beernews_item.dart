import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webfeed/domain/rss_item.dart';

class NewsFeedItem extends StatelessWidget {
  final RssItem _item;

  NewsFeedItem(this._item);

  @override
  Widget build(BuildContext context) {
    var pubDate = new DateFormat("E, d MMM y H:m:s").parse(_item.pubDate);

    return Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
        color: Colors.grey[100],
        child: Card(
            margin: EdgeInsets.all(0.0),
            elevation: 0.0,
            child: Container(
                height: 150.0,
                padding: const EdgeInsets.all(0.0),
                child: Row(children: <Widget>[
                  Image.network(_item.media.thumbnails.length != 0
                      ? _item.media.thumbnails[0].url
                      : TrailAppSettings.defaultThumbnailUrl),
                  SizedBox(width: 8.0),
                  Flexible(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                        Text(_item.title,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 18.0,
                                color: TrailAppSettings.first,
                                fontWeight: FontWeight.bold,
                                fontFamily: "VT323")),
                        SizedBox(
                          height: 4.0,
                        ),
                        Text(
                            _item.author.toUpperCase() +
                                " | " +
                                DateFormat("MMM d y").format(pubDate),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 14.0)),
                        SizedBox(
                          height: 8.0,
                        ),
                        Flexible(
                            fit: FlexFit.tight,
                            child: Text(
                              removeAllHtmlTags(_item.description),
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            )),
                      ]))
                ]))));
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }
}
