import 'package:flutter/material.dart';
import 'package:trailtab_places/util/trailtab_places_settings.dart';

class GuildBadge extends StatelessWidget {
  final double width;

  const GuildBadge({
    Key key,
    this.width = 42.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: InkWell(
        child: Image(
          image: AssetImage(TrailTabPlacesSettings().membershipLogoAsset),
          width: width,
        ),
        onTap: () => showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(image: AssetImage(TrailTabPlacesSettings().membershipLogoAsset), width: 72.0),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Alabama Brewers Guild Member.",
                          style: TextStyle(),
                          maxLines: 10,
                          overflow: TextOverflow.visible,
                        ),
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
