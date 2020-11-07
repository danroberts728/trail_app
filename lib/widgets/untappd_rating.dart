// Copyright (c) 2020, Fermented Software.
import 'dart:math';
import 'package:flutter/material.dart';

/// Provides an Untappd-styled rating with
/// colored-circles representing 0-5 and
/// a numeric representation after.
///
/// Format: * * * * * (3.45)
class UntappdRating extends StatelessWidget {
  /// The rating, from 0 - 5.
  final double rating;

  /// Default constructor
  ///
  /// The [rating] must be between 0 and 5 or it will throw
  /// an assertion error
  const UntappdRating({Key key, @required this.rating})
      : assert(rating >= 0 && rating <= 5),
        super(key: key);

  static Icon _ratingBubbleBase =
      Icon(Icons.circle, color: Colors.grey.withAlpha(125), size: 18.0);
  static Icon _ratingBubbleFilled =
      Icon(Icons.circle, color: Color(0xffffc000), size: 18.0);

  /// Returns a "rating bubble," which is a Widget with a circle
  /// colored to [fillPercent]. So if [fillPercent] is 0.25, then
  /// only 25% of the circle will colored.
  ///
  /// [fillPercent] will be bound between 0,1. If a negative number
  /// is provided, it will be treated as 0. If a number greater than
  /// 1 is provided, it will be treated as 1.
  static Widget _getARatingBubble(double fillPercent) {
    fillPercent = max(0, fillPercent);
    fillPercent = min(1, fillPercent);
    return Stack(
      children: [
        _ratingBubbleBase,
        ClipRect(
          child: Align(
            alignment: Alignment.centerLeft,
            child: _ratingBubbleFilled,
            widthFactor: fillPercent,
            heightFactor: 1,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Rating: ",
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          _getARatingBubble(rating >= 1.0 ? 1.0 : rating),
          _getARatingBubble(rating >= 2.0 ? 1.0 : rating - 1),
          _getARatingBubble(rating >= 3.0 ? 1.0 : rating - 2),
          _getARatingBubble(rating >= 4.0 ? 1.0 : rating - 3),
          _getARatingBubble(rating >= 5.0 ? 1.0 : rating - 4),
          Text(
            rating == 0
            ? " None"
            : " ${rating.toStringAsPrecision(3)} Avg",
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
