import 'package:flutter/material.dart';

class DVThemes {
  static final ThemeData DVLightTheme = new ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xffef5055), //Changing this will change the color of the TabBar
      accentColor: const Color(0x7def5055),
    );
  static final ThemeData DVDarkTheme = new ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xffef5055), //Changing this will change the color of the TabBar
      accentColor: const Color(0x7def5055),
    );
}