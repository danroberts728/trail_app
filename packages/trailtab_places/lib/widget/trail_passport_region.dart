// Copyright (c) 2021, Fermented Software.
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:trail_database/domain/trail_region.dart';
import 'package:trailtab_places/bloc/trail_passport_region_bloc.dart';
import 'package:trail_database/trail_database.dart';
import 'package:trailtab_places/trailtab_places.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// A resuable trail passport
///
/// Intended to be a full-screen overlay
class TrailPassportRegion extends StatelessWidget {
  final TrailRegion region;

  TrailPassportRegion({@required this.region});

  @override
  Widget build(BuildContext context) {
    var bloc = TrailPassportRegionBloc(TrailDatabase(), region: region);

    return StreamBuilder(
      initialData: bloc.stampInformation,
      stream: bloc.stream,
      builder: (context, snapshot) {
        List<StampInformation> stampedPlaces = snapshot.data;
        if (stampedPlaces == null) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: LinearProgressIndicator(),
          );
        } else if (stampedPlaces.isEmpty) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: Text(
              "Nothing yet! Earn a stamp by checking into your first brewery.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
          );
        } else {
          return LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                padding: EdgeInsets.all(0),
                child: Column(
                  children: [
                    Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.start,
                      runAlignment: WrapAlignment.start,
                      runSpacing: 0,
                      spacing: 0,
                      children: stampedPlaces.map((s) {
                        Random rand = Random((s.stampDate != null
                            ? s.stampDate.millisecond
                            : 0));
                        double boxSize = constraints.maxWidth / 3;
                        double leftStampMargin =
                            rand.nextDouble() * (boxSize - 75);
                        double topStampMargin =
                            rand.nextDouble() * (boxSize - 75);
                        double tilt = ((rand.nextInt(30)) * rand.nextDouble()) *
                            (rand.nextBool() ? 1 : -1);
                        return Container(
                          width: boxSize,
                          height: boxSize,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              Feedback.forTap(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      settings: RouteSettings(
                                        name: 'Trail Place - ' + s.place.name,
                                      ),
                                      builder: (context) =>
                                          TrailPlaceDetailScreen(
                                              place: s.place)));
                            },
                            child: Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(32.0),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      colorFilter: ColorFilter.mode(
                                          Colors.white.withOpacity(0.7),
                                          BlendMode.modulate),
                                      image: kIsWeb
                                          ? NetworkImage(s.place.logoUrl)
                                          : CachedNetworkImageProvider(
                                              s.place.logoUrl,
                                            ),
                                    ),
                                  ),
                                ),
                                s.isStamped
                                    ? Positioned(
                                        top: topStampMargin,
                                        left: leftStampMargin,
                                        child: StampedPlaceIcon(
                                            color: Theme.of(context)
                                                .highlightColor,
                                            place: s.place,
                                            firstCheckIn: s.stampDate,
                                            tilt: tilt,
                                            count: s.checkInCount),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
