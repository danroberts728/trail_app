import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TrialPlaceHeader extends StatelessWidget {
  final Widget logo;
  final String name;
  final List<String> categories;
  final double titleFontSize;
  final double categoriesFontSize;
  final TextOverflow titleOverflow;


  TrialPlaceHeader({
    @required this.logo,
    @required this.name,
    @required this.categories, 
    this.titleFontSize = 16.0,   
    this.categoriesFontSize = 14.0,
    this.titleOverflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    return Container(      
      // Trail place logo, name, categories
      margin: EdgeInsets.all(0.0),
      padding: EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        border: null,
        color: Colors.white,
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 12.0,
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
