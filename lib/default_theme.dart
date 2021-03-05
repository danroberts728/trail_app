import 'package:flutter/material.dart';

Color _mainHeadingColor = Color(0xFF93654E);

var defaultTheme = ThemeData(
  brightness: Brightness.dark,
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
);
