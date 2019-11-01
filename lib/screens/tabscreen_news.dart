import 'package:alabama_beer_trail/blocs/trailnews_bloc.dart';
import 'package:alabama_beer_trail/screens/tabscreen_child.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/widgets/trailnews_item.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webfeed/webfeed.dart';

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
  TrailNewsBloc _trailNewsBloc =
      TrailNewsBloc(TrailAppSettings.newsScreenRssFeedUrl);

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 0.0,
      ),
      child: StreamBuilder(
        stream: _trailNewsBloc.trailPlaceStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(snapshot.error.toString()),
              ),
            );
            return Center(child: Text(snapshot.error.toString()));
          } else {
            List<RssItem> newsItems = snapshot.data;
            return ListView.builder(              
              itemCount: newsItems.length,
              itemBuilder: (context, index) {
                if (newsItems == null) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Container(
                    child: TrailNewsItem(newsItems[index]),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
