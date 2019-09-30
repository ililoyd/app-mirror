import 'package:demivolee/controllers/sharedController.dart';
import 'package:demivolee/theme/themes_Collection.dart';
import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  ThemeData _themeData;
  bool _isDark;

  ThemeChanger(){
    _isDark = SharedController.isDarkMode();
    _updatetheme();
  }
  _updatetheme(){
    if(_isDark){
      setTheme(DVThemes.DVDarkTheme);
    }else{
      setTheme(DVThemes.DVLightTheme);
    }
  }

  getTheme() => _themeData;

  setTheme(ThemeData theme) {
    _themeData = theme;

    notifyListeners();
  }
  toogletheme(){ 
    _isDark = !_isDark;
    _updatetheme();
    SharedController.toogleDarkMode();
    
  }
  isDark(){
    return _isDark;
  }
}