import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TrailPlaceGallery extends StatefulWidget {
  final List<String> galleryImageUrls;

  const TrailPlaceGallery({Key key, this.galleryImageUrls}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TrailPlaceGallery();
}

class _TrailPlaceGallery extends State<TrailPlaceGallery> {
  var _currentGalleryIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 3.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              var mainImageWidth = constraints.maxWidth;
              var mainImageHeight = mainImageWidth * (9 / 16);

              return CarouselSlider(
                options: CarouselOptions(
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentGalleryIndex = index;
                    });
                  },
                  viewportFraction: 1.0,
                  height: mainImageHeight,
                  enableInfiniteScroll: widget.galleryImageUrls.length > 1,
                  enlargeCenterPage: false,
                ),
                items: widget.galleryImageUrls.map(
                  (imgUrl) {
                    return Builder(
                      builder: (context) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 3.0),
                          child: kIsWeb
                              ? Image.network(
                                  imgUrl,
                                  fit: BoxFit.cover,
                                  width: mainImageWidth,
                                  height: mainImageHeight,
                                )
                              : CachedNetworkImage(
                                  imageUrl: imgUrl,
                                  fit: BoxFit.cover,
                                  width: mainImageWidth,
                                  height: mainImageHeight,
                                  progressIndicatorBuilder:
                                      (context, url, progress) => Center(
                                    child: CircularProgressIndicator(
                                      value: progress.progress,
                                    ),
                                  ),
                                ),
                        );
                      },
                    );
                  },
                ).toList(),
              );
            },
          ),
        ),
        Visibility(
          visible: widget.galleryImageUrls.length > 1,
          child: Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.galleryImageUrls.map<Widget>((f) {
                bool isCurrentIndex =
                    widget.galleryImageUrls.indexOf(f) == _currentGalleryIndex;
                return AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  width: isCurrentIndex ? 9.0 : 6.0,
                  height: isCurrentIndex ? 9.0 : 6.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white54,
                      ),
                      color: Colors.black54),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
