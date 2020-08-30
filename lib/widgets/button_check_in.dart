import 'package:alabama_beer_trail/blocs/button_check_in_bloc.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
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
  var _bloc = ButtonCheckInBloc();

  @override
  Widget build(BuildContext context) {
    return Visibility(
      // Check in button
      visible: widget.canCheckin || widget.showAlways,
      child: StreamBuilder(
          stream: _bloc.stream,
          initialData: _bloc.checkIns,
          builder: (context, snapshot) {
            bool isCheckedIn = _bloc.isCheckedInToday(widget.place.id);
            return Container(
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  side: BorderSide(
                    color: Colors.black,
                  ),
                ),
                elevation: 4.0,
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                color: TrailAppSettings.actionLinksColor,
                disabledColor: TrailAppSettings.fourth,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Text(
                        isCheckedIn ? "CHECKED IN" : "CHECK IN",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Center(
                        child: Icon(
                          isCheckedIn ? Icons.check : Icons.check_box,
                          color: Colors.white,
                          size: 20.0,
                        ),
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
                          // Check In
                          _bloc.checkIn(widget.place.id).then((newTrophies) {
                            newTrophies.forEach((t) {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text(
                                  "You earned a new achievement: " + t.name,
                                ),
                              ));
                            });
                          });
                        }
                      },
              ),
            );
          }),
    );
  }
}
