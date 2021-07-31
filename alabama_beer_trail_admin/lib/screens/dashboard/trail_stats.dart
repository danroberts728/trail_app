import 'package:flutter/material.dart';

class TrailStats extends StatelessWidget {
  final int totalPlacesCount;
  final int publishedPlacesCount;
  final int unpublishedPlacesCount;

  const TrailStats({
    Key key,
    @required this.totalPlacesCount,
    @required this.publishedPlacesCount,
    @required this.unpublishedPlacesCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Text(
                  "Total Places".toUpperCase(),
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Text(
                totalPlacesCount.toString(),
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.headline5,
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  "Published".toUpperCase(),
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Text(
                publishedPlacesCount.toString(),
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.headline5,
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  "Unpublished".toUpperCase(),
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline5,
                  
                ),
              ),
              Text(
                unpublishedPlacesCount.toString(),
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.headline5,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
