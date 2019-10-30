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
          Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                  phoneTitle,
                  style: TextStyle(
                      color: TrailAppSettings.first,
                      fontSize: 18.0,
                      height: 1.4,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 2,
                child: FlatButton(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.phone),
                      SizedBox(
                        width: 6.0,
                      ),
                      Text(
                        phoneNumber,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                  onPressed: () {
                    AppLauncher().call(phoneNumber);
                  },
                ),
              ),
            ],
          ),
        );
      });
    }

    if (emails != null && emails.length != 0) {
      emails.forEach(
        (emailTitle, emailAddress) {
          retval.add(
            Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(
                    emailTitle,
                    style: TextStyle(
                      color: TrailAppSettings.first,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: FlatButton(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.email),
                        SizedBox(
                          width: 6.0,
                        ),
                        Text(
                          emailAddress,
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                    onPressed: () {
                      AppLauncher().call(emailAddress);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
    return retval;
  }
}
