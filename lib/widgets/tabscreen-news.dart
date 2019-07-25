import 'package:beer_trail_app/util/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;

class NewsFeed extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewsFeed();
  }
}

class _NewsFeed extends State<NewsFeed>
    with AutomaticKeepAliveClientMixin<NewsFeed> {
  RssFeed _rssFeed = RssFeed();
  int _rssFeedItemCount = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    var client = new http.Client();
    client.get(Constants.options.newsScreenRssFeedUrl).then((response) {
      return response.body;
    }).then((bodyString) {
      setState(() {
        this._rssFeed = new RssFeed.parse(bodyString);
        this._rssFeedItemCount = this._rssFeed.items.length;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(children: <Widget>[
      Expanded(
          child: SizedBox(
              height: 300.0,
              child: ListView.builder(
                  padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                  itemCount: _rssFeedItemCount,
                  itemBuilder: (BuildContext context, int index) {
                    return _rssFeed == null
                        ? CircularProgressIndicator()
                        : NewsFeedItem(_rssFeed.items[index]);
                  })))
    ]);
  }
}

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
            elevation: 0.0,
            child: Container(
                height: 150.0,
                padding: const EdgeInsets.all(0.0),
                child: Row(children: <Widget>[
                  Image.network(_item.media.thumbnails.length != 0 ? _item.media.thumbnails[0].url : Constants.options.defaultThumbnailUrl),
                  SizedBox(width: 16.0),
                  Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                    Text(_item.title,
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold, fontFamily: "VT323")),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                        "BY " + _item.author.toUpperCase() + " | " +
                            DateFormat("MMM d y").format(pubDate),
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14.0)),
                    SizedBox(
                      height: 8.0,
                    ),
                    Flexible(
                        fit: FlexFit.tight,
                        child: Text(
                          _item.description,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.fade,
                        )),
                        
                  ]))
                ]))));
  }
}
