// Copyright (c) 2020, Fermented Software.
import 'package:trailtab_wordpress_news/bloc/trailtab_wordpress_news_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Constructor Tests", () {
    test("feed cannot be null", () {
      expect(() => TrailTabWordpressNewsBloc(feedUrl: null),
          throwsA(anything));
    });
    test("read timeout cannot be negative", () {
      expect(() => TrailTabWordpressNewsBloc(feedUrl: 'test.com', readTimeoutSeconds: -12),
          throwsA(anything));
    });
    test("read timeout cannot be 0", () {
      expect(() => TrailTabWordpressNewsBloc(feedUrl: 'test.com', readTimeoutSeconds: 0),
          throwsA(anything));
    });
    test("error message cannot be null", () {
      expect(() => TrailTabWordpressNewsBloc(feedUrl: 'test.com', timeoutErrorMessage: null),
          throwsA(anything));
    });
    test("update frequency cannot be negative", () {
      expect(() => TrailTabWordpressNewsBloc(feedUrl: null, updateFrequencySeconds: -36),
          throwsA(anything));
    });
    test("update frequency cannot be 0", () {
      expect(() => TrailTabWordpressNewsBloc(feedUrl: null, updateFrequencySeconds: 0),
          throwsA(anything));
    });
  });
}