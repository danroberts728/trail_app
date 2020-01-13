import 'package:alabama_beer_trail/util/app_launcher.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webfeed/domain/rss_item.dart';

class TrailNewsItem extends StatelessWidget {
  final RssItem _item;

  TrailNewsItem(this._item);

  @override
  Widget build(BuildContext context) {
    var pubDate = new DateFormat("E, d MMM y H:m:s").parse(_item.pubDate);

    return GestureDetector(
      onTap: () {
        Feedback.forTap(context);
        AppLauncher().openWebsite(_item.link);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
        color: Colors.grey[100],
        child: Card(
          margin: EdgeInsets.all(0.0),
          elevation: 4.0,
          child: Container(
            height: 150.0,
            child: Row(
              children: <Widget>[
                Image(
                  image:
                      _item.media == null || _item.media.thumbnails.length != 0
                          ? CachedNetworkImageProvider(
                              _item.media.thumbnails[0].url,
                            )
                          : AssetImage(
                              TrailAppSettings.defaultNewsThumbnailAsset,
                            ),
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
                      SizedBox(height: 8.0,),
                      Text(_item.title,
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
                          removeAllHtmlTags(_item.description),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ),
                      SizedBox(height: 8.0,),
                      // Date and Author
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.calendar_today,
                            color: TrailAppSettings.subHeadingColor,
                            size: 12.0,
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            DateFormat("MMM d y").format(pubDate),
                            style: TextStyle(
                                color: TrailAppSettings.subHeadingColor, fontSize: 12.0),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Icon(
                            Icons.person,
                            color: TrailAppSettings.subHeadingColor,
                            size: 12.0,
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            _item.dc.creator.toUpperCase(),
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                color: TrailAppSettings.subHeadingColor, fontSize: 12.0),
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
