// Copyright (c) 2021, Fermented Software.
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trailtab_wordpress_news/model/trail_news_post.dart';
import 'package:webfeed/domain/dublin_core/dublin_core.dart';
import 'package:webfeed/domain/media/media.dart';
import 'package:webfeed/domain/media/thumbnail.dart';
import 'package:webfeed/domain/rss_content.dart';
import 'package:webfeed/webfeed.dart';

class RssFeedMock extends Mock implements RssFeed {}

class ImageProviderMock extends Mock implements ImageProvider {}

void main() {
  group("Model building", () {
    test("Properties Test", () {
      var mockProvider = ImageProviderMock();
      TrailNewsPost post = TrailNewsPost(
        content: "Test content",
        creator: "John Doe",
        description: "Test description",
        id: 18,
        imageThumbnail: mockProvider,
        link: "https://freethehops.org",
        publicationDateTime: DateTime(2000, 1, 1),
        title: "Test Title",
      );
      expect(post.content, "Test content");
      expect(post.creator, "John Doe");
      expect(post.description, "Test description");
      expect(post.id, 18);
      expect(post.imageThumbnail, mockProvider);
      expect(post.link, "https://freethehops.org");
      expect(post.publicationDateTime, DateTime(2000, 1, 1));
      expect(post.title, "Test Title");
    });

    test("RSS create Test", () {
      var thumbnailMock = Thumbnail(
        url: "https://freethehops.org/thumbnail.jpg",
        height: "400",
        width: "400",
      );
      RssItem rss = RssItem(
          title: "Test Title 2",
          description: "Test description 2",
          link: "https://freethehops.org/2",
          pubDate: DateTime(2010, 1, 12),
          author: "John Doe",
          guid: "http://freethehops.org/?p=2",
          media: Media(
            thumbnails: <Thumbnail>[thumbnailMock],
          ),
          content: RssContent("Test content 2.", <String>[]),
          dc: DublinCore(
            title: "Test Title",
            creator: "John Doe",
          ));
      TrailNewsPost post = TrailNewsPost.createPostFromRssItem(rss);
      expect(post.content, "Test content 2.");
      expect(post.creator, "John Doe");
      expect(post.description, "Test description 2");
      expect(post.id, 2);
      expect(
          post.imageThumbnail,
          CachedNetworkImageProvider(
            "https://freethehops.org/thumbnail.jpg",
          ));
      expect(post.link, "https://freethehops.org/2");
      expect(post.publicationDateTime, DateTime(2010, 1, 12));
      expect(post.title, "Test Title 2");
    });

    test("Default Thumbnail", () {
      RssItem rss = RssItem(
          title: "Test Title 2",
          description: "Test description 2",
          link: "https://freethehops.org/2",
          pubDate: DateTime(2010, 1, 12),
          author: "John Doe",
          guid: "http://freethehops.org/?p=2",
          media: Media(
            thumbnails: <Thumbnail>[],
          ),
          content: RssContent("Test content 2.", <String>[]),
          dc: DublinCore(
            title: "Test Title",
            creator: "John Doe",
          ));
      TrailNewsPost post = TrailNewsPost.createPostFromRssItem(rss);
      expect(
          post.imageThumbnail,
          AssetImage(
            'assets/newsfeed_empty_image.jpg',
          ));
    });
  });
}
