import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trailtab_wordpress_news/model/trail_news_post.dart';
import 'package:trailtab_wordpress_news/widget/screen_trailnews_post.dart';

void main() {
  TrailNewsPost testPost;

  setUp(() {
    testPost = TrailNewsPost(
      content: "A post with a <a href=\"https://freethehops.org\">a link</a>. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
      creator: "Jane Doe",
      description: "A post",
      id: 21312,
      imageThumbnail: AssetImage(
        'assets/newsfeed_empty_image.jpg',
      ),
      link: "https://freethehops.org/a-post",
      publicationDateTime: DateTime(2020,12,25),
      title: "Merry Christmas and Happy New Year Everyone and this is kind of long",
    );
  });

  group("Screen Trail News Post Tests", () {
    testWidgets("Required Elements Exist", (WidgetTester tester) async {
      MaterialApp testScreenPost = MaterialApp(
        home: Scaffold(
          body: ScreenTrailNewsPost(
            post: testPost,
          ),
        ),
      );
      await tester.pumpWidget(testScreenPost);
      // Thumbnail
      final theThumbnail = find.byKey(ValueKey("ScreenTrailNewsPostThumbnail-21312"));
      expect(theThumbnail, findsOneWidget);
      final theTitle = find.textContaining("Merry Christmas and Happy New Year Everyone and this is kind of long");
      expect(theTitle, findsNWidgets(2));
      final theDateIcon = find.byIcon(Icons.calendar_today);
      expect(theDateIcon, findsOneWidget);
      final theDate = find.text("Dec 25 2020");
      expect(theDate, findsOneWidget);
      final theAuthorIcon = find.byIcon(Icons.person);
      expect(theAuthorIcon, findsOneWidget);
      final theAuthor = find.text("JANE DOE");
      expect(theAuthor, findsOneWidget);
    });
  });
}
