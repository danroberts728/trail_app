import 'package:beer_trail_app/screens/screen_sign_in.dart';
import 'package:beer_trail_app/util/trail_app_settings.dart';
import 'package:flutter/material.dart';

class MustCheckInDialog extends StatelessWidget {
  final message;

  const MustCheckInDialog({Key key, this.message = "Must be signed in"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
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
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      FlatButton(
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                              color: TrailAppSettings.actionLinksColor,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    settings: RouteSettings(
                                      name: 'Sign In',
                                    ),
                                    builder: (context) => ScreenSignIn()));
                          }),
                      FlatButton(
                        child: Text(
                          "Dismiss",
                          style: TextStyle(
                            color: TrailAppSettings.actionLinksColor,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
