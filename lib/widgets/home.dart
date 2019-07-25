import 'tabscreen-trail.dart';
import 'package:flutter/material.dart';
import '../util/const.dart';
import 'placeholder.dart';

class Home extends StatefulWidget {
  @override 
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  Text _appBarTitle = Text(Constants.strings.appName);

  final List<Widget> _children = [
    TrailList(),
    PlaceholderWidget(Colors.blue),
  ];

  final List<Text> _titles = [
    Text(Constants.strings.navBarTrailTabTitle),
    Text(Constants.strings.navBarProfileTabTitle),
  ];

  void onTabTapped(int index) {
    setState( () {
      _currentIndex = index;
      _appBarTitle = _titles[index];
    });
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search), 
            onPressed: () {},
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        backgroundColor: Constants.colors.navBarBackgroundColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Constants.colors.navBarSelectedItemColor,
        showUnselectedLabels: Constants.options.navBarShowUnselectedLabels,
        showSelectedLabels: Constants.options.navBarShowSelectedLabels,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Constants.icons.navBarTrailIcon),
            title: new Text(Constants.strings.navBarTrailLabel),

          ),
          BottomNavigationBarItem(
            icon: new Icon(Constants.icons.navBarProfileIcon),
            title: new Text(Constants.strings.navBarProfileLabel), 
          ),
        ],
      ),
    );
  }
}