// Copyright (c) 2020, Fermented Software.
import 'package:alabama_beer_trail/model/activity_item.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/widgets/profile_user_photo.dart';
import 'package:alabama_beer_trail/widgets/trail_activity_detail_dialog.dart';
import 'package:flutter/material.dart';

import 'package:timeago/timeago.dart' as timeago;

/// A widget for a discrete user activity (check in)
class TrailActivityCard extends StatelessWidget {
  final ActivityItem activity;

  TrailActivityCard({Key key, this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showDialog(
        context: context,
        builder: (context) => TrailActivityDetailDialog(activity: activity,),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        margin: EdgeInsets.symmetric(vertical: 1.0, horizontal: 8.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.5,
              color: Colors.grey,
            ),
          ),
        ),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileUserPhoto(
              activity.userImageUrl,
              backupImage: AssetImage('assets/images/defaultprofilephoto.png'),
              canEdit: false,
              placeholder: CircularProgressIndicator(),
              height: 50,
              width: 50,
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          activity.userDisplayName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: TrailAppSettings.mainHeadingColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        timeago.format(
                          activity.date,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        activity.type == ActivityType.CheckIn
                            ? Icons.where_to_vote_rounded
                            : Icons.emoji_events,
                        size: 18.0,
                        color: TrailAppSettings.attentionColor,
                      ),
                      SizedBox(width: 4.0),
                      Expanded(
                        child: Text(
                          activity.type == ActivityType.CheckIn
                              ? activity.place.name
                              : activity.trophy.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
