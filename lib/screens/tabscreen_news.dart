import 'package:alabama_beer_trail/blocs/tabscreen_news_bloc.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/widgets/trailnews_item.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webfeed/webfeed.dart';

class TabScreenNews extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabScreenNews();
}

class _TabScreenNews extends State<TabScreenNews>
    with AutomaticKeepAliveClientMixin<TabScreenNews> {
  TabScreenNewsBloc _trailNewsBloc =
      TabScreenNewsBloc(TrailAppSettings.newsScreenRssFeedUrl);

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: _refreshPulled,
      child: Container(
        color: Colors.black12,
        margin: EdgeInsets.symmetric(
          horizontal: 0.0,
        ),
        child: StreamBuilder(
          stream: _trailNewsBloc.trailNewsStream,
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
                physics: AlwaysScrollableScrollPhysics(),
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
      ),
    );
  }

  Future<void> _refreshPulled() {
    return Future.delayed(Duration(seconds: 1), () {
      _trailNewsBloc.onReadTimer().then((_) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("News updated.")));
      });
    });
  }
}
