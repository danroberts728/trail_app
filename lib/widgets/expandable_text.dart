import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  ExpandableText(
      {this.text,
      this.isExpanded = false,
      this.fontSize = 16.0,
      this.previewCharacterCount = 50});

  final String text;
  final bool isExpanded;
  final double fontSize;
  final int previewCharacterCount;

  @override
  _ExpandableText createState() =>
      new _ExpandableText(text, isExpanded, fontSize, previewCharacterCount);
}

class _ExpandableText extends State<ExpandableText>
    with TickerProviderStateMixin<ExpandableText> {
  String text;
  bool isExpanded;
  double fontSize;
  int previewCharacterCount;

  String firstHalf;
  String secondHalf;

  _ExpandableText(
      this.text, this.isExpanded, this.fontSize, this.previewCharacterCount);

  @override
  void initState() {
    super.initState();
    if (text != null && text.length > previewCharacterCount) {
      firstHalf = text.substring(0, previewCharacterCount);
      secondHalf = text.substring(previewCharacterCount, text.length);
    } else {
      firstHalf = text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty
          ? Text(firstHalf ?? '')
          : GestureDetector(
              onTap: () {
                setState(() {
                  this.isExpanded = !isExpanded;
                });
              },
              child: Column(
                children: <Widget>[
                  Text(
                    this.isExpanded
                        ? (firstHalf + secondHalf)
                        : (firstHalf + "..."),
                    style: TextStyle(
                      fontSize: this.fontSize,
                    ),
                  ),
                  InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          this.isExpanded ? "show less" : "show more",
                          style: new TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        this.isExpanded = !isExpanded;
                      });
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
