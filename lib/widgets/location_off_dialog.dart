import 'package:alabama_beer_trail/util/location_service.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:flutter/material.dart';

class LocationOffDialog extends StatelessWidget {
  final String message;
  final List<FlatButton> actions;

  const LocationOffDialog({Key key, this.message, this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
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
              children: [
                FlatButton(
                  child: Text(
                    "Allow Location",
                    style: TextStyle(
                      color: TrailAppSettings.actionLinksColor,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    LocationService().refreshLocation().then((location) {
                      if (location == null) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                        "Unable to allow location. This usually means location permission was denied forever. Open app settings on device to change."),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
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
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    }).catchError((err) {
                      print(err);
                    });
                  },
                ),
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
            ),
          ],
        ),
      ),
    );
  }
}
