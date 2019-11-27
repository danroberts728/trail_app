import 'package:alabama_beer_trail/util/app_launcher.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrailPlaceContact extends StatelessWidget {
  final Map<String, String> phones;
  final Map<String, String> emails;

  TrailPlaceContact({Key key, this.phones, this.emails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: _buildContactsList(),
      ),
    );
  }

  List<Widget> _buildContactsList() {
    List<Widget> retval = List<Widget>();

    if (phones != null && phones.length != 0) {
      phones.forEach((phoneTitle, phoneNumber) {
        retval.add(
          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: InkWell(
              onTap: () => AppLauncher().call(phoneNumber),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.phone,
                    color: TrailAppSettings.second,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    phoneNumber,
                    style: TextStyle(
                        color: TrailAppSettings.second,
                        fontSize: 18.0,
                        height: 1.4,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        );
      });
    }

    if (emails != null && emails.length != 0) {
      emails.forEach(
        (emailTitle, emailAddress) {
          retval.add(
            Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: InkWell(
                onTap: () => AppLauncher().email(emailAddress),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.email,
                      color: TrailAppSettings.second,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      emailAddress,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: TrailAppSettings.second,
                          fontSize: 18.0,
                          height: 1.4,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
    return retval;
  }
}
