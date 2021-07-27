import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CompletedTrophy extends StatelessWidget {
  final DateTime completedDate;

  const CompletedTrophy({Key key, this.completedDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat.yMMMd();

    return Center(
      child: Text("Awarded on " + dateFormat.format(completedDate.toLocal()),
        style: TextStyle(
          fontSize: 18.0,
        ),
      )
    );
  }

}