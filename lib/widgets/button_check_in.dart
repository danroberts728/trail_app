import 'package:alabama_beer_trail/blocs/user_checkins_bloc.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/data/check_in.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CheckinButton extends StatefulWidget {
  final bool canCheckin;
  final TrailPlace place;

  CheckinButton({this.canCheckin = false, @required this.place});

  @override
  State<StatefulWidget> createState() => _CheckinButton(canCheckin, place);
}

class _CheckinButton extends State<CheckinButton> {
  bool canCheckin;
  UserCheckinsBloc _userCheckinsBloc = UserCheckinsBloc();
  TrailPlace place;

  _CheckinButton(this.canCheckin, this.place);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      // Check in button
      visible: this.canCheckin,
      child: StreamBuilder(
          stream: _userCheckinsBloc.checkInStream,
          builder: (context, snapshot) {
            List<CheckIn> checkInsToday =
                (snapshot.connectionState == ConnectionState.waiting)
                    ? _userCheckinsBloc.checkIns
                    : snapshot.data;
            var now = DateTime.now();
            var today = DateTime(now.year, now.month, now.day);

            bool isCheckedIn = checkInsToday.any((e) =>
                e.placeId == this.place.id &&
                DateTime(
                        e.timestamp.year, e.timestamp.month, e.timestamp.day) ==
                    today);
            return SizedBox(
              height: 50.0,
              width: double.infinity,
              child: RaisedButton(
                elevation: 8.0,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                color: TrailAppSettings.second.withAlpha(200),
                disabledColor: TrailAppSettings.fourth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                        isCheckedIn
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: Colors.white),
                    SizedBox(
                      width: 12.0,
                    ),
                    Text(
                      isCheckedIn
                          ? "You have checked in today!"
                          : "Tap to Check In!",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                onPressed: isCheckedIn
                    ? null
                    : () {
                        _userCheckinsBloc.checkIn(this.place.id);
                      },
              ),
            );
          }),
    );
  }
}
