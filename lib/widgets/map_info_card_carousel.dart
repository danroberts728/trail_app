// Copyright (c) 2021, Fermented Software.
import 'package:trail_database/domain/trail_place.dart';
import 'package:beer_trail_app/widgets/trailplace_map_info.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class MapInfoCardCarousel extends StatefulWidget {
  final List<TrailPlace> places;
  final int initialCard;

  const MapInfoCardCarousel({Key key, @required this.places, this.initialCard})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MapInfoCardCarousel();
}

class _MapInfoCardCarousel extends State<MapInfoCardCarousel> {
  CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    if (widget.places == null) {
      return SizedBox(
        height: 0,
        width: 0,
      );
    } else {
      return Container(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: CarouselSlider(
            carouselController: _controller,
            options: CarouselOptions(
              initialPage: widget.initialCard,
              autoPlay: false,
              height: 100,
              enableInfiniteScroll: false,
            ),
            items: widget.places.map(
              (p) {
                return TrailPlaceMapInfo(
                  place: p,
                );
              },
            ).toList(),
          ),
        ),
      );
    }
  }

  /// When the state is changed, test to see if the places are identical.
  /// If not, reset the page to 0 (start with left-most)
  @override
  void didUpdateWidget(MapInfoCardCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.places != null &&
        widget.places != null &&
        !oldWidget.places
            .every((e) => widget.places.map((e) => e.id).contains(e.id))) {
      _controller.jumpToPage(0);
    }
  }
}
