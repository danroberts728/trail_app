import 'package:alabama_beer_trail/widgets/tabscreen.dart';

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
  Text _appBarTitle;
  List<IconButton> _appBarActions;

  _HomeState() {
    _appBarTitle = Text(_children[_currentIndex].appBarTitle);
    _appBarActions = _children[_currentIndex].getAppBarActions();
  }

  final List<TabScreen> _children = [
    TabScreen(child: TabScreenTrail(), appBarTitle: Constants.strings.navBarTrailTabTitle,),
    TabScreen(child: TabScreenPlaceholder(Colors.blue), appBarTitle: Constants.strings.navBarProfileTabTitle,),
  ];

  void onTabTapped(int index) {
    setState( () {
      _currentIndex = index;
      _appBarTitle = Text(_children[index].appBarTitle);
      _appBarActions = _children[index].getAppBarActions();
    });
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle,
        actions: _appBarActions,
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