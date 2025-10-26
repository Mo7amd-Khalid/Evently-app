import 'package:flutter/material.dart';

class AppConfigProvider extends ChangeNotifier
{
  ThemeMode themeMode = ThemeMode.light;

  String locale = "en";

  void changeLocale(String newLocale)
  {
    if(locale == newLocale) return;
    locale = newLocale;
    notifyListeners();
  }

  void changeTheme(ThemeMode newTheme)
  {
    if(newTheme == themeMode) return;
    themeMode = newTheme;
    notifyListeners();
  }

  bool isDark(){
    return themeMode == ThemeMode.dark;
  }

  bool isEN(){
    return locale == "en";
  }


}