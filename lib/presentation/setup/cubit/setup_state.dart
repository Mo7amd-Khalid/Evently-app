import 'package:flutter/material.dart';

class SetupState {
  String language;
  ThemeMode mode;

  SetupState({this.language = "en", this.mode = ThemeMode.light});

  SetupState copyWith({String? language, ThemeMode? mode})
  {
    return SetupState(language: language ?? this.language, mode: mode ?? this.mode);
  }

}

sealed class SetupAction {}

class ChangeLanguage extends SetupAction {
  final String language;

  ChangeLanguage(this.language);
}

class ChangeThemeMode extends SetupAction{
  final ThemeMode mode;

  ChangeThemeMode(this.mode);
}

class GoToOnboardingScreen extends SetupAction{

}


sealed class SetupNavigation{}

class NavigateToOnboardingScreen extends SetupNavigation{}