import 'package:alabama_beer_trail/blocs/user_checkins_bloc.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/data/check_in.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CheckinButton extends StatefulWidget {
  final bool canCheckin;
  final TrailPlace place;
  final bool showAlways;

  CheckinButton(
      {this.canCheckin = false, @required this.place, this.showAlways = false});

  @override
  State<StatefulWidget> createState() => _CheckinButton();
}

class _CheckinButton extends State<CheckinButton> {
  UserCheckinsBloc _userCheckinsBloc = UserCheckinsBloc();

  @override
  Widget build(BuildContext context) {
    return Visibility(
      // Check in button
      visible: widget.canCheckin || widget.showAlways,
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
                e.placeId == widget.place.id &&
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
                        if (!widget.canCheckin) {
                          showGeneralDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierColor: Colors.black.withOpacity(0.4),
                              transitionDuration: Duration(milliseconds: 300),
                              barrierLabel: '',
                              transitionBuilder:
                                  (context, anim1, anim2, child) {
                                return Transform.scale(
                                  alignment: Alignment.center,
                                  scale: anim1.value,
                                  child: child,
                                );
                              },
                              pageBuilder: (context, anim1, anim2) {
                                return Material(
                                  type: MaterialType.transparency,
                                  child: Center(
                                    child: SizedBox(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 2.0,
                                            )),
                                        padding: EdgeInsets.all(16.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              "You are not close enough to check in to " +
                                                  widget.place.name,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 22.0,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 24.0,
                                            ),
                                            RaisedButton(
                                              child: Text(
                                                "Close",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              color: TrailAppSettings.second,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                          return null;
                        } else {
                          return _userCheckinsBloc.checkIn(widget.place.id);
                        }
                      },
              ),
            );
          }),
    );
  }
}
