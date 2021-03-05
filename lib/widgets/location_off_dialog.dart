import 'package:beer_trail_app/util/location_service.dart';
import 'package:beer_trail_app/util/trail_app_settings.dart';
import 'package:flutter/material.dart';

class LocationOffDialog extends StatelessWidget {
  final String message;
  final LocationService locationService;

  const LocationOffDialog({
    Key key,
    @required this.locationService,
    @required this.message,
  }) : super(key: key);

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
            Wrap(
              alignment: WrapAlignment.end,
              children: [
                TextButton(
                  child: Text(
                    "Allow Location",
                    style: TextStyle(
                      color: TrailAppSettings.actionLinksColor,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    locationService.refreshLocation().then((location) {
                      if (location == null) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              key: ValueKey('unable-to-allow-location-dialog'),
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
                                        "Unable to allow location. This usually means location permission was permanently denied. Open app settings on device to change."),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
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
                TextButton(
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
