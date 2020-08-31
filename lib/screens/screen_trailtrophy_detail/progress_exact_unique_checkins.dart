import 'package:alabama_beer_trail/blocs/trophy_progress_checkins_bloc.dart';
import 'package:alabama_beer_trail/data/trail_trophy_exact_unique_checkins.dart';
import 'package:alabama_beer_trail/screens/screen_trailplace_detail/screen_trailplace_detail.dart';
import 'package:alabama_beer_trail/widgets/trailplace_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TrailTrophyProgressExactUniqueCheckins extends StatelessWidget {
  final TrailTrophyExactUniqueCheckins trophy;

  TrailTrophyProgressExactUniqueCheckins({Key key, @required this.trophy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TrophyProgressCheckinsBloc _bloc = TrophyProgressCheckinsBloc();

    return StreamBuilder(
      stream: _bloc.stream,
      initialData: _bloc.placeStatuses,
      builder: (context, AsyncSnapshot<List<TrailPlaceCheckInStatus>> snapshot) {
        List<TrailPlaceCheckInStatus> trailPlaces = snapshot.data;
        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: trophy.requiredCheckins.length,
          itemBuilder: (context, index) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            var trophyPlaces = trophy.requiredCheckins..sort();

            TrailPlaceCheckInStatus place = trailPlaces.firstWhere(
              (p) => p.place.id == trophyPlaces[index],
              orElse: () {
                return null;
              },
            );

            if (place == null) {
              return Container(
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.warning,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 6.0,
                    ),
                    Text(
                      "Error - Place doesn't exist",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }
            return GestureDetector(
              onTap: () {
                Feedback.forTap(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    settings: RouteSettings(
                      name: place.place.name,
                    ),
                    builder: (context) => TrailPlaceDetailScreen(
                      place: place.place,
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
                    place.hasUniqueCheckin
                        ? Icon(Icons.check, color: Colors.green)
                        : Icon(Icons.close, color: Colors.red),
                    Expanded(
                      child: Container(
                        child: TrialPlaceHeader(
                          name: place.place.name,
                          categories: place.place.categories,
                          titleFontSize: 16.0,
                          categoriesFontSize: 12.0,
                          titleOverflow: TextOverflow.ellipsis,
                          alphaValue: 0,
                          logo: CachedNetworkImage(
                            imageUrl: place.place.logoUrl,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
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
