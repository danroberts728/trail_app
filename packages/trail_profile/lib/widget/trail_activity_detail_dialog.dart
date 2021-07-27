// Copyright (c) 2020, Fermented Software.
import 'package:trail_profile/model/activity_item.dart';
import 'package:trail_profile/widget/profile_user_photo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// The dialog that shows when a user taps on an activity. Shows
/// a little more detail than the TrailActvityCard
class TrailActivityDetailDialog extends StatelessWidget {
  final ActivityItem activity;

  const TrailActivityDetailDialog({Key key, @required this.activity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String date = DateFormat("MMMM d, yyyy").format(activity.date);
    String time = DateFormat("h:mm a").format(activity.date);

    return SimpleDialog(
      contentPadding: EdgeInsets.all(16.0),
      children: <Widget>[
        Row(
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
                  Text(
                    activity.userDisplayName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  Row(
                    children: [
                      Icon(
                        activity.type == ActivityType.CheckIn
                            ? Icons.where_to_vote_rounded
                            : Icons.emoji_events,
                        size: 18.0,
                        color: Theme.of(context).highlightColor,
                      ),
                      SizedBox(width: 4.0),
                      Expanded(
                        child: Text(
                          activity.type == ActivityType.CheckIn
                              ? activity.place.name
                              : activity.trophy.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
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
        SizedBox(height: 8.0,),
        Text("Checked in on $date at $time.")
      ],
    );
  }
}
