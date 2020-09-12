import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:flutter/material.dart';

class GuildBadge extends StatelessWidget {
  final String assetNameIcon;
  final String assetNameDialogImage;
  final double width;

  const GuildBadge({
    Key key,
    this.assetNameIcon = 'assets/images/guild_logo_state.png',
    this.assetNameDialogImage = 'assets/images/guild_logo_state_color.png',
    this.width = 36.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.0,
      child: FlatButton(
        padding: EdgeInsets.all(0),
        child: Image(
          image: AssetImage(assetNameIcon),
          width: width,
        ),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Image(image: AssetImage(assetNameDialogImage), width: 72.0),
                  SizedBox(width: width),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Alabama Brewers Guild Member",
                          style: TextStyle(),
                          maxLines: 10,
                          overflow: TextOverflow.visible,
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
