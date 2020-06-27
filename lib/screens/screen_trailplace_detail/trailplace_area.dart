import 'package:flutter/material.dart';

class TrailPlaceArea extends StatelessWidget {
  final bool isVisible;
  final Widget child;

  const TrailPlaceArea({Key key, this.isVisible = false, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        padding: EdgeInsets.only(bottom: 0.0,),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.5, color: Colors.black45),
          ),
        ),
        child: child,
      ),
    );
  }
}
