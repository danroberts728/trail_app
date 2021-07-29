import 'package:flutter/material.dart';
import 'package:trail_database/domain/trail_place.dart';
import 'package:trail_location_service/location_off_dialog.dart';
import 'package:trail_location_service/trail_location_service.dart';
import 'package:trailtab_places/bloc/textbutton_stamp_bloc.dart';
import 'package:trailtab_places/widget/must_sign_in_dialog.dart';
import 'package:trailtab_places/widget/screen_new_badge.dart';

class TextButtonStamp extends StatelessWidget {
  static const String stampLabel = "STAMP PASSPORT";
  static const String checkinLabel = "CHECK IN";
  static const String checkedinLabel = "CHECKED IN";

  final bool visible;
  final bool showAlways;
  final TrailPlace place;
  final TextButtonStampBloc bloc;

  const TextButtonStamp(
      {Key key,
      @required this.visible,
      this.showAlways = false,
      @required this.bloc,
      @required this.place})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String buttonLabel = stampLabel;
    Color labelColor = Theme.of(context).buttonColor;

    if(bloc.isStamped() && !bloc.isCheckedInToday()) {
      buttonLabel = checkinLabel;
    } else if (bloc.isCheckedInToday()) {
      buttonLabel = checkedinLabel;
      labelColor = Theme.of(context).highlightColor;
    }

    return Visibility(
      visible: visible,
      child: TextButton(
        child: Row(
          children: [
            Text(
              buttonLabel,
              style: TextStyle(
                color: labelColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        onPressed: bloc.isCheckedInToday()
            ? null
            : () => onPressed(context),
      ),
    );
  }

  void onPressed(context) {
    if (!bloc.isSignedIn()) {
      showDialog(
        context: context,
        builder: (context) => MustCheckInDialog(
          message:
              "It looks like you aren't signed in. Please sign in to check in.",
        ),
      );
    } else if (!bloc.isLocationOn()) {
      showDialog(
        context: context,
        builder: (context) => LocationOffDialog(
          locationService: TrailLocationService(),
          message:
              "It looks like we can't access your location. Please turn on location to check in to ${place.name}",
        ),
      );
    } else if (!bloc.isCloseEnoughToCheckIn(place.location)) {
      _showCheckInButtonDialog(
        context: context,
        message:
            "It looks like you're not at ${place.name} yet. Please try again when you get closer.",
        actions: [
          TextButton(
            child: Text(
              "Dismiss",
              style: TextStyle(
                color: Theme.of(context).buttonColor,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      );
    } else {
      // Check In
      bloc.checkIn()
        /*..then((newTrophies) {
          Navigator.push(
            context,
            MaterialPageRoute(
              settings: RouteSettings(name: '/feedback'),
              builder: (context) => ScreenFeedback(place: place),
            ),
          );
          return newTrophies;
        })*/.then(
          (newTrophies) {
            if (newTrophies.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  settings: RouteSettings(name: '/newbadges'),
                  builder: (context) => ScreenNewBadges(
                    newTrophies: newTrophies,
                  ),
                ),
              );
            }
          },
        );
    }
  }

  Future<Dialog> _showCheckInButtonDialog(
      {@required BuildContext context,
      @required String message,
      List<TextButton> actions}) {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: TextStyle(),
                maxLines: 10,
                overflow: TextOverflow.visible,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions,
              ),
            ],
          ),
        ),
      ),
    );
  }
}