import 'dart:async';

import 'bloc.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;

class TrailNewsBloc extends Bloc {  
  final String feedUrl;
  Timer _timer;

  TrailNewsBloc(this.feedUrl) {
    onReadTimer().then((_) {
      _timer = Timer(Duration(seconds: 120), onReadTimer);
    });
    
  }

  List<RssItem> newsItems = List<RssItem>();
  final _trailNewsController = StreamController<List<RssItem>>();
  Stream<List<RssItem>> get trailPlaceStream => _trailNewsController.stream;

  Future<void> onReadTimer() {
    var client = http.Client();
    client.get(this.feedUrl).then(
      (response) {
        var newNews = RssFeed.parse(response.body);
        _trailNewsController.add(newNews.items);
      },
    ).timeout(Duration(seconds: 115), onTimeout: () {
      _trailNewsController.addError("Unable to get news");
    });
    return Future.value();
  }

  @override
  void dispose() {
    _trailNewsController.close();
    _timer.cancel();
  }
}
