// Copyright (c) 2021, Fermented Software
import 'dart:async';

import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;

/// BLoC for the TrailWordpressNews Widget
class TrailTabWordpressNewsBloc {
  /// The URL for the Wordpress feed. This can be
  /// a whole site feed, a category feed, or any other
  /// RSS feed.
  final String feedUrl;

  /// The error message to return when the feed reader
  /// times out.
  final String timeoutErrorMessage;

  /// How often to check for new posts, in seconds
  final int updateFrequencySeconds;

  /// How long to wait for posts before we timeout
  final int readTimeoutSeconds;

  Timer _timer;

  TrailTabWordpressNewsBloc(
      {this.feedUrl,
      this.timeoutErrorMessage,
      this.updateFrequencySeconds,
      this.readTimeoutSeconds})
      : assert(updateFrequencySeconds > 0),
        assert(readTimeoutSeconds > 0) {
    onReadTimer().then((_) {
      _timer = Timer(Duration(seconds: updateFrequencySeconds), onReadTimer);
    });
  }

  final _streamController = StreamController<List<RssItem>>.broadcast();
  Stream<List<RssItem>> get trailNewsStream => _streamController.stream;

  Future<void> onReadTimer() {
    var client = http.Client();
    client.get(Uri.parse(feedUrl)).then(
      (response) {
        var newNews = RssFeed.parse(response.body);
        _streamController.add(newNews.items);
      },
    ).timeout(Duration(seconds: readTimeoutSeconds), onTimeout: () {
      _streamController.addError(timeoutErrorMessage);
    }).onError((error, stackTrace) {
      _streamController.addError(error.toString());
    });
    return Future.value();
  }

  void dispose() {
    _streamController.close();
    _timer.cancel();
  }
}
