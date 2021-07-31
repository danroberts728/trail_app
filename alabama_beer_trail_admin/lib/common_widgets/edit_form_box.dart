import 'package:flutter/material.dart';

class EditFormBox extends StatefulWidget {
  final String title;
  final double width;
  final List<Widget> children;

  const EditFormBox(
      {Key key,
      @required this.title,
      @required this.width,
      @required this.children})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _EditFormBox();
}

class _EditFormBox extends State<EditFormBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      width: widget.width,
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(125),
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: Colors.grey, width: 1.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 14.0,
            ),
          ),
        ]..addAll(widget.children),
      ),
    );
  }
}
