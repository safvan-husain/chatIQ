import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData light = ThemeData(
      brightness: Brightness.light,
      visualDensity: const VisualDensity(vertical: 0.5, horizontal: 0.5),
      primarySwatch: const MaterialColor(
        0xFFE0E0E0, // Set the primary color to white
        <int, Color>{
          50: Color(0xFFFAFAFA),
          100: Color(0xFFF5F5F5),
          200: Color(0xFFEAEAEA),
          300: Color(0xFFE0E0E0),
          400: Color(0xFFD6D6D6),
          500: Color(0xFFCCCCCC),
          600: Color(0xFFC2C2C2),
          700: Color(0xFFB8B8B8),
          800: Color(0xFFADADAD),
          900: Color(0xFFA3A3A3),
        },
      ),
      primaryColorLight: const Color.fromARGB(224, 247, 246, 246),
      primaryColorDark: const Color.fromARGB(255, 131, 130, 128),
      canvasColor: const Color.fromARGB(255, 243, 240, 236),
      scaffoldBackgroundColor: const Color.fromARGB(224, 247, 246, 246),
      dividerColor: const Color.fromARGB(231, 4, 4, 4),
      focusColor: const Color.fromARGB(255, 103, 151, 239),
      splashColor: const Color.fromARGB(255, 31, 106, 245),
      cardColor: const Color.fromARGB(255, 228, 231, 233));
  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    visualDensity: const VisualDensity(vertical: 0.5, horizontal: 0.5),
    primarySwatch: const MaterialColor(
      0xFFF5E0C3,
      <int, Color>{
        50: Color(0xFF1A1A1A),
        100: Color(0xFF1A1A1A),
        200: Color(0xFF1A1A1A),
        300: Color(0xFF1A1A1A),
        400: Color(0xFF1A1A1A),
        500: Color(0xFF1A1A1A),
        600: Color(0xFF1A1A1A),
        700: Color(0xFF1A1A1A),
        800: Color(0xFF1A1A1A),
        900: Color(0xFF1A1A1A),
      },
    ),
    primaryColor: const Color.fromARGB(255, 21, 21, 21),
    primaryColorLight: const Color(0x1a311F06),
    primaryColorDark: const Color(0xff936F3E),
    canvasColor: const Color(0xffE09E45),
    scaffoldBackgroundColor: const Color.fromARGB(128, 109, 110, 110),
    cardColor: const Color.fromARGB(170, 35, 34, 34),
    dividerColor: const Color.fromARGB(255, 253, 252, 255),
    focusColor: const Color.fromARGB(255, 103, 151, 239),
  );
}
