import 'package:alabama_beer_trail/data/trail_place.dart';
import 'package:alabama_beer_trail/data/trail_place_category.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:alabama_beer_trail/widgets/trailplace_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TrailListView extends StatefulWidget {
  final List<TrailPlace> places;

  TrailListView({this.places});

  @override
  State<StatefulWidget> createState() => _TrailListView();
}

class _TrailListView extends State<TrailListView> {
  String searchQuery;
  final TextEditingController _searchController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    var initialShow = Map<TrailPlaceCategory, bool>();
    TrailAppSettings.filterStrings.forEach((f) => initialShow[f] = true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          // Search
          Container(
            height: 50.0,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            color: TrailAppSettings.third.withAlpha(25),
            child: TextField(
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
              controller: _searchController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            searchQuery = "";
                          });
                        },
                      ),
                isDense: true,
                labelText: '',
                hintText: '',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            ),
          ),
          // ListView
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: widget.places.length,
                itemBuilder: (BuildContext context, int index) {
                  if (widget.places.length < 1) {
                    return Center(child: Text("Nothing to show"));
                  } else {
                    if (searchQuery == null || searchQuery.isEmpty) {
                      return TrailListCard(
                        place: widget.places[index],
                      );
                    } else if (widget.places[index].name
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase())) {
                      return TrailListCard(
                        place: widget.places[index],
                      );
                    } else {
                      return Container();
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
