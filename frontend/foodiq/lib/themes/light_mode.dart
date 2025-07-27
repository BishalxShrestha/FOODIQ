import 'package:flutter/material.dart';

final ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Color(0xff6c9dfe), // your custom main color
    // background: Colors.white,
    // secondary: Colors.deepPurple,
    onPrimary: Colors.white,
    // onBackground: Colors.black,
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor:Color(0xff6c9dfe),
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xff6c9dfe),
      foregroundColor: Colors.white,
    ),
  ),
);
