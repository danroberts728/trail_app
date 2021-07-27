// Copyright (c) 2021, Fermented Software.
import 'package:flutter/material.dart';

class TrailPlaceArea extends StatelessWidget {
  final bool isVisible;
  final Widget child;
  final bool bottomBorder;
  final bool topBorder;

  const TrailPlaceArea({Key key, this.isVisible = false, this.child, this.bottomBorder = true, this.topBorder = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
        padding: EdgeInsets.only(bottom: 0.0,),
        decoration: BoxDecoration(
          border: Border(       
            top: topBorder
              ? BorderSide(width: 0.5, color: Colors.black45)
              : BorderSide(width: 0.0, color: Colors.transparent),    
            bottom: bottomBorder
              ? BorderSide(width: 0.5, color: Colors.black45)
              : BorderSide(width: 0.0, color: Colors.transparent),
          ),
        ),
        child: child,
      ),
    );
  }
}
