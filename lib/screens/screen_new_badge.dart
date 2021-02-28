// Copyright (c) 2020, Fermented Software.
import 'package:beer_trail_database/domain/trail_trophy.dart';
import 'package:beer_trail_app/util/trail_app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

/// Modal screen that pops up when user earns a new badge(s)
class ScreenNewBadges extends StatefulWidget {
  /// The new trohies to show.
  final List<TrailTrophy> newTrophies;

  /// Default constructor
  const ScreenNewBadges({Key key, @required this.newTrophies})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScreenNewBadges();
}

/// State for ScreenNewBadges
class _ScreenNewBadges extends State<ScreenNewBadges> {
  ConfettiController _confettiController;

  /// Initialize the staet
  /// 
  /// Instantiate the confetti controller
  @override
  void initState() {
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool multiple = widget.newTrophies.length > 1;
    _confettiController.play();

    return Scaffold(
      appBar: AppBar(
        title: Text(multiple ? "New Badges" : "New Badge"),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 8.0),
                  Text(
                    multiple
                        ? "You have earned new badges"
                        : "You have earned a new badge",
                    style: TextStyle(
                      color: TrailAppSettings.subHeadingColor,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    children: widget.newTrophies
                        .map(
                          (t) => Column(
                            children: [
                              SizedBox(
                                height: 16.0,
                              ),
                              Center(
                                child: CachedNetworkImage(
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                  fit: BoxFit.scaleDown,
                                  imageUrl: t.activeImage,
                                ),
                              ),
                              Center(
                                child: Text(
                                  t.name,
                                  textAlign: TextAlign.center,
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
                                  t.description,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black54,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 100,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              numberOfParticles: 20,
              colors: [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Dipose the object
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }
}
