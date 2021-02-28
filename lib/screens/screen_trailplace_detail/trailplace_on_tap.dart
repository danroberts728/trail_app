// Copyright (c) 2020, Fermented Software.
import 'package:trail_database/domain/on_tap_beer.dart';
import 'package:beer_trail_app/util/app_launcher.dart';
import 'package:beer_trail_app/util/trail_app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// UI element for a list of taps at a trail place
class TrailPlaceOnTap extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TrailPlaceOnTap();

  /// The place ID for the taps
  final List<TapListExpansionItem> tapItems;

  const TrailPlaceOnTap({Key key, @required this.tapItems}) : super(key: key);
}

class _TrailPlaceOnTap extends State<TrailPlaceOnTap> {
  @override
  Widget build(BuildContext context) {
    List<TapListExpansionItem> tapItems = widget.tapItems;
    // sort prices
    return ListView(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          child: Text("This information is provided by the venue's point of sale system. The accuracy of the listings and prices is not guaranteed.",
            style: TextStyle(
              fontSize: 14.0,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        ExpansionPanelList(
          elevation: 0,
          animationDuration: Duration(seconds: 1),
          expansionCallback: (panelIndex, isExpanded) {
            setState(() {
              tapItems[panelIndex].isExpanded = !isExpanded;
            });
          },
          children: tapItems.map(
            (tapItem) {
              OnTapBeer tap = tapItem.tap;
              return ExpansionPanel(
                canTapOnHeader: true,
                isExpanded: tapItem.isExpanded,
                headerBuilder: (context, isExpanded) {
                  return Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Visibility(
                          visible:
                              tap.logoUrl != null && tap.logoUrl.isNotEmpty,
                          child: CachedNetworkImage(
                            imageUrl: tap.logoUrl,
                            height: 40.0,
                            width: 40.0,
                            alignment: Alignment.centerLeft,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Visibility(
                          visible:
                              tap.logoUrl != null && tap.logoUrl.isNotEmpty,
                          child: SizedBox(
                            width: 16.0,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Brewery Name
                              // We're going to assume this exists, which may be a mistake...
                              Text(
                                tap.manufacturer,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black87,
                                  height: 1.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              // Beer Name
                              // We're going to assume this exists
                              Text(
                                tap.name,
                                maxLines: tapItem.isExpanded ? 4 : 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: TrailAppSettings.mainHeadingColor,
                                  height: 1.1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // ABV, IBU, and style
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  // Beer Style
                                  Visibility(
                                    visible: tap.style != null &&
                                        tap.style.isNotEmpty,
                                    child: Text(
                                      tap.style,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.black87,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                  // Dot (if style and either ABV or IBU exists)
                                  Visibility(
                                    visible: (tap.style != null &&
                                            tap.style.isNotEmpty) &&
                                            (
                                              (tap.abv != null && tap.abv.isNotEmpty) ||
                                              (tap.ibu != null && tap.ibu != 0)
                                            ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      height: 4.0,
                                      width: 4.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  // ABV
                                  Visibility(
                                    visible:
                                        tap.abv != null && tap.abv.isNotEmpty,
                                    child: Text(
                                      "ABV ${tap.abv}%",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  // Dot (if IBU exists)
                                  Visibility(
                                    visible: tap.ibu != null &&
                                            tap.ibu != 0,
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      height: 4.0,
                                      width: 4.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ), 
                                  // IBU
                                  Visibility(
                                    visible: tap.ibu != null && tap.ibu != 0,
                                    child: Text(
                                      "IBU ${tap.ibu.toString()}",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                body: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Description (if present)
                      Visibility(
                        visible: tap.description.isNotEmpty,
                        child: Text(tap.description,
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      // Space below description (if present)
                      Visibility(
                        visible: tap.description.isNotEmpty,
                        child: SizedBox(
                          height: 8.0,
                        ),
                      ),
                      // Pricing (if present)
                      Visibility(
                        visible: tap.prices.length > 0,
                        child: Container(
                          width: double.infinity,
                          child: Column(
                            children: tap.prices.map((p) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    p.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4.0),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            style: BorderStyle.solid,
                                            color: Colors.grey[300],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "\$${p.price.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      // Untappd Link
                      Visibility(
                        visible:
                            tap.untappdUrl != null && tap.untappdUrl.isNotEmpty,
                        child: InkWell(
                          onTap: () {
                            // Get number part of URL
                            String untappdBeerId = tap.untappdUrl.split("/").last;
                            AppLauncher().openUntappdBeer(untappdBeerId);
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                                border: Border(
                              top: BorderSide(color: Colors.grey[200]),
                              bottom: BorderSide(color: Colors.grey[200]),
                            )),
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.untappd,
                                  color: TrailAppSettings.subHeadingColor,
                                  size: 14.0,
                                ),
                                SizedBox(
                                  width: 14.0,
                                ),
                                Text(
                                  "Open in Untappd",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Icon(
                                    Icons.exit_to_app_outlined,
                                    color: TrailAppSettings.actionLinksColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}

class TapListExpansionItem {
  final OnTapBeer tap;
  bool isExpanded;

  TapListExpansionItem({@required this.tap, this.isExpanded = false}) {
    tap.prices.sort((a,b) => a.price.compareTo(b.price));
  }
}
