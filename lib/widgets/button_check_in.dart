// Copyright (c) 2020, Fermented Software.
import 'package:alabama_beer_trail/blocs/button_check_in_bloc.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/util/appauth.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/widgets/must_check_in_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CheckinButton extends StatefulWidget {
  final bool canCheckin;
  final TrailPlace place;
  final bool showAlways;
  final ButtonCheckInBloc bloc;

  CheckinButton(
      {@required this.bloc,
      @required this.place,
      this.canCheckin = false,
      this.showAlways = false,
      })
      : assert(bloc != null),
        assert(place != null);

  @override
  State<StatefulWidget> createState() => _CheckinButton();
}

class _CheckinButton extends State<CheckinButton> {
  ButtonCheckInBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc;    
  }

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
                        if (AppAuth().user == null) {
                          showDialog(
                            context: context,
                            builder: (context) => MustCheckInDialog(
                              message: "You must be signed in to check in.",
                            ),
                          );
                        } else if (!widget.canCheckin) {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "You are not close enough to check in to " +
                                                widget.place.name,
                                            style: TextStyle(),
                                            maxLines: 10,
                                            overflow: TextOverflow.visible,
                                          ),
                                          FlatButton(
                                            child: Text(
                                              "Dismiss",
                                              style: TextStyle(
                                                color: TrailAppSettings
                                                    .actionLinksColor,
                                              ),
                                            ),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
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
