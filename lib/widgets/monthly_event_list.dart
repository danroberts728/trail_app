import 'package:alabama_beer_trail/blocs/events_bloc.dart';
import 'package:alabama_beer_trail/data/trailevent.dart';
import 'package:alabama_beer_trail/util/const.dart';
import 'package:alabama_beer_trail/widgets/trailevent_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthlyEventsList extends StatefulWidget {
  final DateTime month;

  const MonthlyEventsList({Key key, @required this.month}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MonthlyEventsList(this.month);
  }
}

class _MonthlyEventsList extends State<MonthlyEventsList> {
  final DateTime month;
  MonthlyEventsBloc _thisMonthEventsBloc;

  _MonthlyEventsList(this.month) {
    this._thisMonthEventsBloc = MonthlyEventsBloc(month);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> columnList = <Widget>[
      EventMonthHeader(
        month: this.month,
      )
    ];

    return StreamBuilder(
      stream: _thisMonthEventsBloc.trailEventsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          List<TrailEvent> events = snapshot.data..sort((TrailEvent a, TrailEvent b) {
            return a.eventStart.compareTo(b.eventStart);
          });
          if(events.length == 0) {
            columnList.add(Text("No Events scheduled yet"));
          }
          events.forEach((e) {
            columnList.add(
              TrailEventCard(
                event: e,
              ),
            );
          });
        }

        return Container(
          child: Column(
            children: columnList,
          ),
        );
      },
    );
  }
}

class EventMonthHeader extends StatelessWidget {
  final DateTime month;

  const EventMonthHeader({Key key, this.month}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.topLeft,
      margin: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 16.0,
      ),
      child: Text(
        DateFormat("MMMM").format(this.month).toUpperCase() +
            ", " +
            DateFormat("yyyy").format(this.month).toUpperCase(),
        textAlign: TextAlign.start,
        style: TextStyle(
          color: Constants.colors.third,
          fontFamily: "Roboto",
          fontFamilyFallback: ["arial narrow"],
          fontSize: 22.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
