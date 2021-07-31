import 'package:beer_trail_admin/screens/dashboard/dashboard_bloc.dart';
import 'package:beer_trail_admin/screens/dashboard/dashboard_box.dart';
import 'package:beer_trail_admin/screens/dashboard/trail_stats.dart';
import 'package:flutter/material.dart';

class DashBoard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DashBoard();
}

class _DashBoard extends State<DashBoard> {
  DashboardBloc _bloc = DashboardBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: _bloc.dashboardData,
      stream: _bloc.stream,
      builder: (context, snapshot) {
        DashboardData dashboardData = snapshot.data;
        return LayoutBuilder(
          builder: (context, constraints) {
            return Wrap(
              alignment: WrapAlignment.start,
              runSpacing: 32.0,
              children: [
                // Trail Place Stats
                DashboardBox(
                  title: "Places Stats",
                  leading: Icon(Icons.location_on, color: Colors.black87),
                  child: TrailStats(
                    totalPlacesCount: dashboardData.totalPlacesCount,
                    publishedPlacesCount: dashboardData.publishedPlacesCount,
                    unpublishedPlacesCount:
                        dashboardData.unpublishedPlacesCount,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
