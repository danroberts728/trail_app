import 'package:flutter/material.dart';

class DashboardBox extends StatelessWidget {
  final Color color;
  final Widget child;
  final double minWidth;
  final String title;
  final Widget leading;
  final Color titleTextColor;

  const DashboardBox(
      {Key key,
      @required this.title,
      this.color = Colors.white70,
      @required this.child,
      this.minWidth = 400.0,
      this.leading,
      this.titleTextColor = Colors.black87})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        width: constraints.maxWidth < 600
            ? constraints.maxWidth
            : minWidth,
        child: ExpansionTile(
          initiallyExpanded: true,
          leading: leading,
          backgroundColor: color,
          collapsedBackgroundColor: color,
          title: Text(title,
            style: TextStyle(
              color: titleTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            ListTile(
              title: Container(
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
