library trailtab_wordpress_news;

// Copyright (c) 2020, Fermented Software.
import 'package:trailtab_wordpress_news/bloc/trailtab_wordpress_news_bloc.dart';
import 'package:trailtab_wordpress_news/widget/trailnews_item.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webfeed/webfeed.dart';

/// The screen for a Wordpress news tab
class TrailTabWordpressNews extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TrailTabWordpressNews();

  final String rssFeed;
  final String timeoutErrorMessage;
  final int updateFrequencySeconds;
  final int readTimeoutSeconds;

  TrailTabWordpressNews({
    @required this.rssFeed,
    this.timeoutErrorMessage =
        "We're having a hard time getting the news. It may be a problem with the Internet connection.",
    this.updateFrequencySeconds = 120,
    this.readTimeoutSeconds = 115,
  });
}

class _TrailTabWordpressNews extends State<TrailTabWordpressNews>
    with AutomaticKeepAliveClientMixin<TrailTabWordpressNews> {
  TrailTabWordpressNewsBloc _trailNewsBloc;

  ScrollController _controller = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _trailNewsBloc = TrailTabWordpressNewsBloc(
      feedUrl: widget.rssFeed,
      timeoutErrorMessage: widget.timeoutErrorMessage,
      updateFrequencySeconds: widget.updateFrequencySeconds,
      readTimeoutSeconds: widget.readTimeoutSeconds,
    );
    super.initState();
  }

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
              return Center(child: Icon(Icons.error));
            } else {
              List<RssItem> newsItems = snapshot.data;
              return ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                controller: _controller,
                itemCount: newsItems.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: TrailNewsItem(
                      item: newsItems[index],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _refreshPulled() {
    return _trailNewsBloc.onReadTimer().then((_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("News updated.")));
    });
  }
}
