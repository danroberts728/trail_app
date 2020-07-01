import 'package:alabama_beer_trail/blocs/trail_places_bloc.dart';
import 'package:alabama_beer_trail/blocs/user_checkins_bloc.dart';
import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/data/trail_trophy_exact_unique_checkins.dart';
import 'package:alabama_beer_trail/screens/screen_trailplace_detail/screen_trailplace_detail.dart';
import 'package:alabama_beer_trail/widgets/trailplace_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TrailTrophyProgressExactUniqueCheckins extends StatelessWidget {
  final TrailTrophyExactUniqueCheckins trophy;

  const TrailTrophyProgressExactUniqueCheckins({Key key, @required this.trophy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TrailPlacesBloc _trailPlacesBloc = TrailPlacesBloc();

    UserCheckinsBloc _userCheckinsBloc = UserCheckinsBloc();

    return StreamBuilder(
      stream: _trailPlacesBloc.trailPlaceStream,
      builder: (context, trailPlacesSnapshot) {
        List<TrailPlace> trailPlaces = trailPlacesSnapshot.data;
        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: trophy.requiredCheckins.length,
          itemBuilder: (context, index) {
            if(trailPlacesSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            var trophyPlaces = trophy.requiredCheckins..sort();

            TrailPlace place =
                trailPlaces.firstWhere((p) => p.id == trophyPlaces[index]);

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
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey, width: 0.2),
                  ),
                ),
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
              ),
            );
          },
        );
      },
    );
  }
}
