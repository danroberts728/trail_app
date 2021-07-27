import 'package:trail_auth/trail_auth.dart';
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
                      TextButton(
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                              color: Theme.of(context).buttonColor,
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
                      TextButton(
                        child: Text(
                          "Dismiss",
                          style: TextStyle(
                            color: Theme.of(context).buttonColor,
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
