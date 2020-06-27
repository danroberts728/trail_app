import 'package:alabama_beer_trail/blocs/trail_places_bloc.dart';
import 'package:alabama_beer_trail/blocs/user_checkins_bloc.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/data/trail_trophy.dart';
import 'package:alabama_beer_trail/screens/screen_trailplace_detail/screen_trailplace_detail.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/widgets/trailplace_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrophyDetailScreen extends StatelessWidget {
  final TrailTrophy trophy;

  final TrailPlacesBloc _trailPlacesBloc = TrailPlacesBloc();

  final UserCheckinsBloc _userCheckinsBloc = UserCheckinsBloc();

  TrophyDetailScreen({Key key, this.trophy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(trophy.name)),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 16.0,
              ),
              Center(
                child: CachedNetworkImage(
                  fit: BoxFit.contain,
                  imageUrl: trophy.activeImage,
                ),
              ),
              Center(
                child: Text(
                  trophy.name,
                  style: TextStyle(
                    fontSize: 22.0,
                    color: TrailAppSettings.mainHeadingColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Center(
                child: Text(
                  trophy.description,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontStyle: FontStyle.italic,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Divider(
                color: TrailAppSettings.second,
              ),
              Center(
                child: Text(
                  "Progress",
                  style: TextStyle(
                    color: TrailAppSettings.subHeadingColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              StreamBuilder(
                stream: _trailPlacesBloc.trailPlaceStream,
                builder: (context, trailPlacesSnapshot) {
                  return StreamBuilder(
                    stream: _userCheckinsBloc.checkInStream,
                    builder: (context, userCheckinSnapshot) {
                      if (trailPlacesSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      List<TrailPlace> trailPlaces = trailPlacesSnapshot.data;
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: trophy.requiredPlaces.length,
                        itemBuilder: (context, index) {
                          var trophyPlaces = trophy.requiredPlaces..sort();

                          TrailPlace place = trailPlaces
                              .firstWhere((p) => p.id == trophyPlaces[index]);

                          var uniqueCheckIns = _userCheckinsBloc.checkIns
                              .map((f) {
                                return f.placeId;
                              })
                              .toSet()
                              .toList()
                                ..sort();
                          return GestureDetector(
                            onTap: () {
                              Feedback.forTap(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  settings: RouteSettings(
                                    name: place.name,
                                  ),
                                  builder: (context) => TrailPlaceDetailScreen(
                                    place: place,
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: <Widget>[
                                uniqueCheckIns.contains(place.id)
                                    ? Icon(Icons.check, color: Colors.green)
                                    : Icon(Icons.close, color: Colors.red),
                                Expanded(
                                  child: Container(
                                    child: TrialPlaceHeader(
                                      name: place.name,
                                      categories: place.categories,
                                      titleFontSize: 16.0,
                                      categoriesFontSize: 12.0,
                                      titleOverflow: TextOverflow.ellipsis,
                                      alphaValue: 0,
                                      logo: CachedNetworkImage(
                                        imageUrl: place.logoUrl,
                                        placeholder: (context, url) =>
                                            RefreshProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                        width: 25.0,
                                        height: 25.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
