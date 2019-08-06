import '../widgets/tabscreenchild.dart';
import 'package:flutter/material.dart';

class TabScreenPlaceholder extends StatelessWidget
implements TabScreenChild {
 final Color color;

 TabScreenPlaceholder(this.color);

 @override
 Widget build(BuildContext context) {
   return Container(
     color: color,
   );
 }

  @override
  List<IconButton> getAppBarActions() {
    return List<IconButton>();
  }
}