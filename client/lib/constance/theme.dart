import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    visualDensity: const VisualDensity(vertical: 0.5, horizontal: 0.5),
    // primarySwatch: const MaterialColor(
    //   0xFFF5E0C3,
    //   <int, Color>{
    //     50: Color(0x1aF5E0C3),
    //     100: Color(0xa1F5E0C3),
    //     200: Color(0xaaF5E0C3),
    //     300: Color(0xafF5E0C3),
    //     400: Color(0xffF5E0C3),
    //     500: Color(0xffEDD5B3),
    //     600: Color(0xffDEC29B),
    //     700: Color(0xffC9A87C),
    //     800: Color(0xffB28E5E),
    //     900: Color(0xff936F3E)
    //   },
    // ),
    primarySwatch: Colors.blue,
    primaryColor: const Color.fromARGB(255, 199, 199, 198),
    primaryColorLight: const Color(0x1aF5E0C3),
    primaryColorDark: const Color(0xff936F3E),
    canvasColor: const Color(0xffE09E45),
    scaffoldBackgroundColor: const Color.fromARGB(226, 255, 255, 255),
    cardColor: const Color.fromARGB(255, 253, 253, 253),
    dividerColor: const Color(0x1f6D42CE),
    focusColor: const Color(0x1aF5E0C3));

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
