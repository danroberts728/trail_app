import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:webfeed/domain/rss_item.dart';

class TrailNewsPost {
  final int id;
  final DateTime publicationDateTime;
  final String link;
  final ImageProvider imageThumbnail;
  final String title;
  final String description;
  final String creator;
  final String content;

  TrailNewsPost(
      {this.id,
      this.publicationDateTime,
      this.link,
      this.imageThumbnail,
      this.title,
      this.description,
      this.creator,
      this.content});

  static fromRssItem(RssItem rss) {
    Uri uri = Uri.dataFromString(rss.guid);
    String postId = uri.queryParameters['p'];
    return TrailNewsPost(
      id: int.tryParse(postId) ?? 0,
      publicationDateTime: rss.pubDate,
      link: rss.link,
      imageThumbnail: rss.media == null || rss.media.thumbnails.length != 0
          ? CachedNetworkImageProvider(
              rss.media.thumbnails.first.url,
            )
          : AssetImage(
              TrailAppSettings.defaultNewsThumbnailAsset,
            ),
      title: rss.title,
      description: rss.description,
      creator: rss.dc.creator,
      content: rss.content.value,
    );
  }
}
