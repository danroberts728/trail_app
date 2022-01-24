// Copyright (c) 2020, Fermented Software.
import 'package:trail_profile/bloc/profile_favorites_bloc.dart';
import 'package:trail_database/trail_database.dart';
import 'package:trailtab_places/trailtab_places.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// A horizontally-scrolled list of the user's favorite places,
/// designed for use in the user's profile
class ProfileFavorites extends StatelessWidget {
  final ProfileFavoritesBloc _bloc = ProfileFavoritesBloc(TrailDatabase());

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.stream,
      initialData: _bloc.favorites,
      builder: (context, snapshot) {
        List<TrailPlace> places = snapshot.data;
        if (places == null) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: LinearProgressIndicator(),
          );
        } else if (places.isEmpty) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "Nothing yet! Favorite your first brewery and it will show up here.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
          );
        } else {
          return Container(
            padding: EdgeInsets.only(left: 16.0),
            height: 85.0,
            child: Scrollbar(
              controller: _scrollController,
              isAlwaysShown: true,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: places.length,
                itemBuilder: (context, index) {
                  TrailPlace p = places[index];
                  return InkWell(
                    onTap: () {
                      Feedback.forTap(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          settings: RouteSettings(
                            name: 'Trail Place - ' + p.name,
                          ),
                          builder: (context) => TrailPlaceDetailScreen(
                            place: p,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: CachedNetworkImage(
                        imageUrl: p.logoUrl,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}
