// Copyright (c) 2020, Fermented Software.
import 'package:beer_trail_app/blocs/button_check_in_bloc.dart';
import 'package:beer_trail_app/data/trail_place.dart';
import 'package:beer_trail_app/screens/screen_new_badge.dart';
import 'package:trail_auth/trail_auth.dart';
import 'package:beer_trail_app/util/location_service.dart';
import 'package:beer_trail_app/util/trail_app_settings.dart';
import 'package:beer_trail_app/widgets/location_off_dialog.dart';
import 'package:beer_trail_app/widgets/must_check_in_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CheckinButton extends StatefulWidget {
  final TrailPlace place;
  final bool showAlways;
  final TrailAuth appAuth;
  final ButtonCheckInBloc bloc;

  CheckinButton({
    @required this.bloc,
    @required this.place,
    @required this.appAuth,
    this.showAlways = false,
  })  : assert(bloc != null),
        assert(place != null),
        assert(appAuth != null);

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
      visible: _bloc.isCloseEnoughToCheckIn(widget.place.location) || widget.showAlways,
      child: StreamBuilder(
        stream: _bloc.stream,
        initialData: _bloc.checkIns,
        builder: (context, snapshot) {
          bool isCheckedIn = _bloc.isCheckedInToday(widget.place.id);
          bool isStamped = _bloc.isStamped(widget.place.id);
          return Container(
            child: RaisedButton(
              key: ValueKey("${widget.place.id}-checkin-key"),
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
                      isCheckedIn
                          ? "CHECKED IN"
                          : isStamped
                              ? "CHECK IN"
                              : "STAMP PASSPORT",
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
                      if (widget.appAuth.user == null) {
                        showDialog(
                          context: context,
                          builder: (context) => MustCheckInDialog(
                            message: "It looks like you aren't signed in. Please sign in to check in.",
                          ),
                        );
                      } else if (!_bloc.isLocationOn()) {
                        showDialog(
                          context: context,
                          builder: (context) => LocationOffDialog(
                            locationService: LocationService(),
                            message: "It looks like we can't access your location. Please turn on location to check in to ${widget.place.name}",
                          ),
                        );
                      } else if (!_bloc.isCloseEnoughToCheckIn(widget.place.location)) {
                        _showCheckInButtonDialog(
                          context: context,
                          message: "It looks like you're not at ${widget.place.name} yet. Please try again when you get closer.",
                          actions: [
                            FlatButton(
                              child: Text(
                                "Dismiss",
                                style: TextStyle(
                                  color: TrailAppSettings.actionLinksColor,
                                ),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            )
                          ],
                        );
                      } else {
                        // Check In
                        _bloc.checkIn(widget.place.id).then(
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
                    },
            ),
          );
        },
      ),
    );
  }

  Future<Dialog> _showCheckInButtonDialog(
      {@required BuildContext context,
      @required String message,
      List<FlatButton> actions}) {
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
