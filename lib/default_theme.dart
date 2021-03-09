import 'package:flutter/material.dart';

Color _mainHeadingColor = Color(0xFF93654E);
Color _subTitleColor = Color(0xFF4E7C93); 

var defaultTheme = ThemeData(
  brightness: Brightness.light,
  buttonColor: Color(0xFF5A934E),
  primarySwatch: MaterialColor(_mainHeadingColor.value, {
    50: _mainHeadingColor.withOpacity(0.1),
    100: _mainHeadingColor.withOpacity(0.2),
    200: _mainHeadingColor.withOpacity(0.3),
    300: _mainHeadingColor.withOpacity(0.4),
    400: _mainHeadingColor.withOpacity(0.5),
    500: _mainHeadingColor.withOpacity(0.6),
    600: _mainHeadingColor.withOpacity(0.7),
    700: _mainHeadingColor.withOpacity(0.8),
    800: _mainHeadingColor.withOpacity(0.9),
    900: _mainHeadingColor.withOpacity(1),
  }),
  appBarTheme: AppBarTheme(
    brightness: Brightness.dark,
  ),
  hintColor: Colors.white,
  textTheme: TextTheme(
      headline1: TextStyle(
        color: _mainHeadingColor,
        fontSize: 22.0,
        fontWeight: FontWeight.bold,
      ),
      headline2: TextStyle(
        color: _mainHeadingColor,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
      headline3: TextStyle(
        color: _mainHeadingColor,
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
      headline4: TextStyle(color: _mainHeadingColor),
      headline5: TextStyle(color: _mainHeadingColor),
      headline6: TextStyle(color: _mainHeadingColor),
      subtitle1: TextStyle(
        color: _subTitleColor,
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
      ),
      subtitle2: TextStyle(
        color: _subTitleColor,
        fontSize: 12.0,
        fontWeight: FontWeight.w500,
      ),
  ),
);
