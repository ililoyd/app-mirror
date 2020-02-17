import 'package:shared_preferences/shared_preferences.dart';

class SharedController {
  
  static SharedPreferences prefs;

  static getInstance() async{
    final prefs = await SharedPreferences.getInstance();
    SharedController.prefs = prefs;
  }

  static bool isFavorite(index){
    prefs = SharedController.prefs;
    
    List<String> list = prefs.getStringList("favorites") ?? List();
    return list.contains(index.toString());
  }

  static toogleFavorite(index){
     prefs = SharedController.prefs;

    List<String> list = prefs.getStringList("favorites") ?? List();
    if (list.contains(index.toString())) {
      list.remove(index.toString());
    }
    else{
      list.add(index.toString());
    }
    prefs.setStringList("favorites", list);
  }

  static toogleDarkMode(){
    prefs = SharedController.prefs;
    bool isDarkModeEnabled = prefs.getBool("dark_mode") ?? false;

    prefs.setBool("dark_mode", !isDarkModeEnabled);
  }

  static isDarkMode(){
    prefs = SharedController.prefs;

    bool isDarkModeEnabled = prefs.getBool("dark_mode");
    if (isDarkModeEnabled == null){
      isDarkModeEnabled = false;
      prefs.setBool("dark_mode", isDarkModeEnabled);
    }
    return isDarkModeEnabled;
  }

  static String getFavoritesList(){
    prefs = SharedController.prefs;
    
    List<String> list = prefs.getStringList("favorites") ?? List();
    
    String favString = "";
    list.forEach((e) => favString = favString + e +",");

    return favString;
  }
}