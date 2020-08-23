import 'package:alabama_beer_trail/blocs/events_bloc.dart';
import 'package:alabama_beer_trail/data/trail_event.dart';
import 'package:alabama_beer_trail/widgets/trailevent_card.dart';
import 'package:flutter/material.dart';

class TabScreenEvents extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabScreenEvents();
}

class _TabScreenEvents extends State<TabScreenEvents> {
  @override
  Widget build(BuildContext context) {
    EventsBloc eventsBloc = EventsBloc();

    return RefreshIndicator(
      onRefresh: _refreshPulled,
      child: Container(
        color: Colors.black12,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: StreamBuilder(
            stream: eventsBloc.trailEventsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        TrailEvent event = snapshot.data[index];
                        return TrailEventCard(
                          startMargin: 4.0,
                          endMargin: 4.0,
                          showImage: true,
                          elevation: 8.0,
                          event: event,
                        );
                      },
                    ),
                    Visibility(
                      visible:
                          snapshot.data == null || snapshot.data.length == 0,
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.all(50.0),
                          child: Text(
                            "There are currently no upcoming events scheduled",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future<void> _refreshPulled() {
    return Future.delayed(Duration(seconds: 1), () {
      setState(() {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("Events list updated.")));
      });
    });
  }
}
