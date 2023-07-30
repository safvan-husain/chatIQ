import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
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
  dividerColor: const Color(0x1f6D42CE),
  focusColor: const Color.fromARGB(255, 103, 151, 239),
  splashColor: Color.fromARGB(255, 31, 106, 245),
);

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    visualDensity: const VisualDensity(vertical: 0.5, horizontal: 0.5),
    primarySwatch: const MaterialColor(
      0xFFF5E0C3,
      <int, Color>{
        50: Color(0x1a5D4524),
        100: Color(0xa15D4524),
        200: Color(0xaa5D4524),
        300: Color(0xaf5D4524),
        400: Color(0x1a483112),
        500: Color(0xa1483112),
        600: Color(0xaa483112),
        700: Color(0xff483112),
        800: Color(0xaf2F1E06),
        900: Color(0xff2F1E06)
      },
    ),
    primaryColor: const Color(0xff5D4524),
    primaryColorLight: const Color(0x1a311F06),
    primaryColorDark: const Color(0xff936F3E),
    canvasColor: const Color(0xffE09E45),
    scaffoldBackgroundColor: const Color.fromARGB(128, 109, 110, 110),
    cardColor: const Color(0xaa311F06),
    dividerColor: const Color(0x1f6D42CE),
    focusColor: const Color(0x1a311F06));
