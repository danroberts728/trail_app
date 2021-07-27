// Copyright (c) 2020, Fermented Software.
import 'package:trail_profile/widget/trail_activity_log.dart';
import 'package:flutter/material.dart';

/// A full-screen activity log
class ScreenFullActivityLog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Activity"),
      ),
      body: SingleChildScrollView(
        child: TrailActivityLog(),
      ),
    );
  }
}
