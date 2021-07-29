import 'package:flutter/material.dart';
//import 'package:trailtab_places/bloc/feedback_photo_bloc.dart';

class FeedbackPhoto extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FeedbackPhoto();
}

class _FeedbackPhoto extends State<FeedbackPhoto> {
  //FeedbackPhotoBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        switch(snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return Text("Waiting");
          case ConnectionState.done:
            return Text("Done");
          default:
            return Text("What?");
        }
      },
    ) ;
  }

}