import 'package:flutter/material.dart';

import '../../core/constant/app_constants.dart';

ThemeData dark = ThemeData(
  fontFamily: AppConstants.fontFamily,
  primaryColor: const Color(0xFF252B5C),
  secondaryHeaderColor: const Color(0xFFefe6fc),
  brightness: Brightness.dark,
  cardColor: const Color(0xFF29292D),
  hintColor: const Color(0xFFE7F6F8),
  focusColor: const Color(0xFFC3CAD9),
  shadowColor: Colors.black.withOpacity(0.4),
  popupMenuTheme: const PopupMenuThemeData(color: Color(0xFF29292D), surfaceTintColor: Color(0xFF29292D)),
  dialogTheme: const DialogTheme(surfaceTintColor: Colors.white10),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF1F4C6B)), // Set background color to brown
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set text color to white
      ),
    ),
  outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(0),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set background color to brown
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white10), // Set text color to white
        side: MaterialStateProperty.all<BorderSide>(BorderSide(color: const Color(0xFF1F4C6B), width: 1)), // Add border
      )
  ),
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    background: const Color(0xFF212121),
    onBackground: const Color(0xFFC3CAD9),
    onPrimary: const Color(0xFF252B5C),
    primary: const Color(0xFF1F4C6B),
    secondary: const Color(0xFFefe6fc),
    onSecondary: const Color(0xFFefe6fc),
    error: Colors.redAccent,
    onError: Colors.redAccent,
    surface: Colors.white10,
    onSurface:  Colors.white70,
    shadow: Colors.black.withOpacity(0.4),
  ),


);
