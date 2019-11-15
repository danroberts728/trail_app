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
          RaisedButton(
              elevation: 4.0,
              padding: EdgeInsets.all(8.0),
              color: TrailAppSettings.third,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              onPressed: () {
                AppLauncher().call(phoneNumber);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    phoneTitle,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        height: 1.4,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
        );
      });
    }

    if (emails != null && emails.length != 0) {
      emails.forEach(
        (emailTitle, emailAddress) {
          retval.add(
            RaisedButton(
              elevation: 4.0,
              padding: EdgeInsets.all(8.0),
              color: TrailAppSettings.third,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              onPressed: () {
                AppLauncher().email(emailAddress);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    emailTitle,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        height: 1.4,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
    return retval;
  }
}
