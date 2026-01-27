import 'package:evently/core/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

extension ContextFunc on BuildContext{
  TextTheme get textStyle => Theme.of(this).textTheme;

  // media query
  double get heightSize => MediaQuery.sizeOf(this).height;
  double get widthSize => MediaQuery.sizeOf(this).width;

  AppLocalizations? get locale => AppLocalizations.of(this);
}