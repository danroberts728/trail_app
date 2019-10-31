import 'package:alabama_beer_trail/screens/tabscreen_child.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/widgets/beernews_item.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;

class TabScreenNews extends StatefulWidget implements TabScreenChild {
  @override
  State<StatefulWidget> createState() => _TabScreenNews();  

  @override
  List<IconButton> getAppBarActions() {
    return List<IconButton>();
  }
}

class _TabScreenNews extends State<TabScreenNews>
    with AutomaticKeepAliveClientMixin<TabScreenNews> {
  RssFeed _rssFeed = RssFeed();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    var client = new http.Client();
    client.get(TrailAppSettings.newsScreenRssFeedUrl).then((response) {
      return response.body;
    }).then((bodyString) {
      setState(() {
        this._rssFeed = new RssFeed.parse(bodyString);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 0.0,
      ),
      child: ListView.builder(
        itemCount: _rssFeed.items.length,
        itemBuilder: (context, index) {
          return Container(
            child: NewsFeedItem(this._rssFeed.items[index]),
          );
        },
      )
    );
  }
}