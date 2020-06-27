import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  ExpandableText(
      {this.text,
      this.isExpanded = false,
      this.fontSize = 16.0,
      this.previewCharacterCount = 50,
      this.minCharacterCountToExpand = 60});

  final String text;
  final bool isExpanded;
  final double fontSize;
  final int previewCharacterCount;
  final int minCharacterCountToExpand;

  @override
  _ExpandableText createState() => new _ExpandableText();
}

class _ExpandableText extends State<ExpandableText>
    with TickerProviderStateMixin<ExpandableText> {
  bool _isExpanded = false;
  String _firstHalf;
  String _secondHalf;

  @override
  void initState() {
    super.initState();
    this._isExpanded = widget.isExpanded;
    if (widget.text != null &&
        widget.text.length > widget.minCharacterCountToExpand) {
      _firstHalf = widget.text.substring(0, widget.previewCharacterCount);
      _secondHalf = widget.text
          .substring(widget.previewCharacterCount, widget.text.length);
    } else {
      _firstHalf = widget.text;
      _secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 8.0),
      child: _secondHalf.isEmpty
          ? Text(
              _firstHalf ?? ',',
              style: TextStyle(
                fontSize: widget.fontSize,
              ),
            )
          : GestureDetector(
              onTap: () {
                Feedback.forTap(context);
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Column(
                children: <Widget>[
                  Text(
                    this._isExpanded
                        ? (_firstHalf + _secondHalf)
                        : (_firstHalf + "..."),
                    style: TextStyle(
                      fontSize: widget.fontSize,
                    ),
                  ),
                  InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          _isExpanded ? "show less" : "show more",
                          style: new TextStyle(
                              color: TrailAppSettings.actionLinksColor),
                        ),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
