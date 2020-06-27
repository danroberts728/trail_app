import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TrialPlaceHeader extends StatelessWidget {
  final Widget logo;
  final String name;
  final List<String> categories;
  final double titleFontSize;
  final double categoriesFontSize;
  final TextOverflow titleOverflow;
  final int alphaValue;
  final double leadingSpace;


  TrialPlaceHeader({
    @required this.logo,
    @required this.name,
    @required this.categories, 
    this.titleFontSize = 16.0,   
    this.categoriesFontSize = 14.0,
    this.titleOverflow = TextOverflow.ellipsis,
    this.alphaValue = 255, this.leadingSpace = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(      
      // Trail place logo, name, categories
      margin: EdgeInsets.all(0.0),
      padding: EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        border: null,
        color: Color.fromARGB(this.alphaValue, 255, 255, 255),        
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: this.leadingSpace,
          ),
          logo,
          SizedBox(
            width: 12.0,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  name,
                  overflow: titleOverflow,
                  style: TextStyle(
                    color: Color(0xff93654e),
                    fontWeight: FontWeight.bold,
                    fontSize: titleFontSize,
                  ),
                ),
                Text(
                  (this.categories..sort()).join(", "),
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                    fontSize: categoriesFontSize,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
