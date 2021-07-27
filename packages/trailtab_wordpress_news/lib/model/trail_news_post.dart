// Copyright (c) 2021, Fermented Software.
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';

/// A logical representation of a Wordpress news post
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

  static createPostFromRssItem(RssItem rss) {
    Uri uri = Uri.dataFromString(rss.guid);
    String postId = uri.queryParameters['p'];
    return TrailNewsPost(
      id: int.parse(postId),
      publicationDateTime: rss.pubDate,
      link: rss.link,
      imageThumbnail: rss.media.thumbnails.length != 0
          ? CachedNetworkImageProvider(
              rss.media.thumbnails.first.url,
            )
          : AssetImage(
              'assets/newsfeed_empty_image.jpg',
            ),
      title: rss.title,
      description: rss.description,
      creator: rss.dc.creator,
      content: rss.content.value,
    );
  }
}