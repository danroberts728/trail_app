// Copyright (c) 2021, Fermented Software.
import 'package:flutter/material.dart';
import 'package:trail_database/domain/trail_region.dart';
import 'package:trail_database/trail_database.dart';
import 'package:trailtab_places/bloc/trail_passport_bloc.dart';
import 'package:trailtab_places/widget/trail_passport_region.dart';

class TrailPassport extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TrailPassport();
}

/// A resuable trail passport
///
/// Intended to be a full-screen overlay
class _TrailPassport extends State<TrailPassport>
    with TickerProviderStateMixin {
  /// The controller for the sub-tab
  ///
  /// The tabs switch between the list and map screens
  TabController _controller;

  TrailPassportBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = TrailPassportBloc(TrailDatabase());
    _controller = getTabController();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.stream,
      initialData: _bloc.regions,
      builder: (context, snapshot) {
        List<TrailRegion> data = snapshot.data;
        data.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        if (_controller.length != data.length) {
          _controller = getTabController();
        }
        return Column(
          children: [
            Container(
              child: TabBar(
                isScrollable: true,
                indicatorColor: Theme.of(context).textTheme.button.color,
                indicatorWeight: 4.0,
                labelColor: Theme.of(context).textTheme.subtitle1.color,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                tabs: data.map((e) => Tab(child: Text(e.name))).toList(),
                controller: _controller,
              ),
            ),
            Expanded(
              child: Container(
                child: TabBarView(
                  controller: _controller,
                  children: _getWidgets(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  TabController getTabController() {
    return TabController(length: _bloc.regions.length, vsync: this)
      ..addListener(_updatePage);
  }

  void _updatePage() {
    setState(() {});
  }

  List<Widget> _getWidgets() {
    List<Widget> widgets = <Widget>[];
    _bloc.regions.forEach((region) {
      widgets.add(
        SingleChildScrollView(
          child: TrailPassportRegion(
            region: region,
          ),
        ),
      );
    });
    return widgets;
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
