import 'dart:async';

import 'package:trail_database/trail_database.dart';

class TrailPlaceEditBloc {
  TrailDatabase _db = TrailDatabase();
  TrailPlace place;

  TempPlace editablePlace;

  TrailPlaceEditBloc({String placeId}) : assert(placeId != null) {
    place = _db.places.firstWhere((p) => p.id == placeId);
    editablePlace = TempPlace(
      name: place.name,
      categories: place.categories,
      published: place.published,
    );
  }

  StreamController<TempPlace> _controller = StreamController<TempPlace>();
  Stream<TempPlace> get stream => _controller.stream;

  void addCategory(String category) {
    if (!editablePlace.categories.contains(category)) {
      editablePlace.categories.add(category);
      _controller.add(editablePlace);
    }
  }

  void removeCategory(String category) {
    if (editablePlace.categories.contains(category)) {
      editablePlace.categories.remove(category);
      _controller.add(editablePlace);
    }
  }

  void changePublishStatus(bool value) {
    editablePlace.published = value;
    _controller.add(editablePlace);
  }

  dispose() {
    _controller.close();
  }
}

class TempPlace {
  String name;
  List<String> categories;
  bool published;

  TempPlace({this.name, this.categories, this.published});
}
