import 'package:flutter/material.dart';

import '../../core/constant/app_constants.dart';

ThemeData light = ThemeData(
  fontFamily: AppConstants.fontFamily,
  primaryColor: const Color(0xFF252B5C),
  secondaryHeaderColor: const Color(0xFFEFE6FE),
  brightness: Brightness.light,
  cardColor: const Color(0xFFF5F4F8),
  focusColor: const Color(0xFFC3CAD9),
  hintColor: const Color(0xFF52575C),
  canvasColor: const Color(0xFFFCFCFC),
  shadowColor: const Color(0xFF52575C),
  textTheme: const TextTheme(bodyMedium: TextStyle(color: Color(0xFF002349))),
  popupMenuTheme: const PopupMenuThemeData(color: Colors.white, surfaceTintColor: Colors.white),
  dialogTheme: const DialogTheme(surfaceTintColor: Colors.white),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF1F4C6B)), // Set background color to brown
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set text color to white
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      elevation: MaterialStateProperty.all<double>(0),
      foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFF1F4C6B)), // Set background color to brown
      backgroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set text color to white
      side: MaterialStateProperty.all<BorderSide>(BorderSide(color: const Color(0xFF1F4C6B), width: 1)), // Add border
    )
  ),
  colorScheme: ColorScheme(
    background: const Color(0xFFFCFCFC),
    brightness: Brightness.light,
    onPrimary: const Color(0xFF252B5C),
    primary: const Color(0xFF1F4C6B),
    secondary: const Color(0xFFEFE6FE),
    onSecondary: const Color(0xFFEFE6FE),
    error: Colors.redAccent,
    onError: Colors.redAccent,
    onBackground: const Color(0xFFC3CAD9),
    surface: Colors.white,
    onSurface:  const Color(0xFF002349),
    shadow: Colors.grey[300],
  ),
);