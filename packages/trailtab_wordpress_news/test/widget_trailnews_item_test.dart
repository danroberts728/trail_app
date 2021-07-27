import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trailtab_wordpress_news/widget/trailnews_item.dart';
import 'package:webfeed/domain/dublin_core/dublin_core.dart';
import 'package:webfeed/domain/media/media.dart';
import 'package:webfeed/domain/media/thumbnail.dart';
import 'package:webfeed/domain/rss_content.dart';
import 'package:webfeed/webfeed.dart';

class RssItemMock extends Mock implements RssItem {}

void main() {
  RssItemMock mockRss = RssItemMock();

  setUp(() {
    when(mockRss.guid).thenReturn("https://freethehops.org/?p=2132");
    when(mockRss.pubDate).thenReturn(DateTime(2020, 5, 12));
    when(mockRss.link).thenReturn("https://freethehops.org/test-post");
    when(mockRss.media).thenReturn(Media(thumbnails: <Thumbnail>[]));
    when(mockRss.title).thenReturn("Test Title That is Really Long and Probably needs to be truncated");
    when(mockRss.description).thenReturn("A post");
    when(mockRss.dc).thenReturn(DublinCore(creator: "Jane Doe"));
    when(mockRss.content).thenReturn(RssContent(
        "A post with <a href=\"https://freethehops.org\">a link</a>.",
        <String>[]));
  });

  group("Trail News Item Tests", () {
    testWidgets("Required Elements Exist", (WidgetTester tester) async {
      MaterialApp testNewsItem = MaterialApp(
        home: Scaffold(
          body: TrailNewsItem(
            item: mockRss,
          ),
        ),
      );
      await tester.pumpWidget(testNewsItem);
      // Thumbnail
      final theThumbnail = find.byKey(ValueKey("TrailnewsThumbnail-2132"));
      expect(theThumbnail, findsOneWidget);
      // Title
      final theTitle = find.textContaining("Test Title");
      expect(theTitle, findsOneWidget);
      // Date
      final theDateIcon = find.byIcon(Icons.calendar_today);
      expect(theDateIcon, findsOneWidget);
      final theDate = find.textContaining("May 12 2020");
      expect(theDate, findsOneWidget);
      // Author
      final theAuthorIcon = find.byIcon(Icons.person);
      expect(theAuthorIcon, findsOneWidget);
      final theAuthor = find.textContaining("JANE DOE");
      expect(theAuthor, findsOneWidget);
    });
  });
}
