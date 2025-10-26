import 'package:evently/l10n/generated/app_localizations.dart';

class DataValidation{
  static String? nameValidation(String value, AppLocalizations locale){
    if (value.isEmpty) {
      return locale.nameRequired;
    } else if (!RegExp(r'^[A-Za-z\u0600-\u06FF ]+$').hasMatch(value)) {
      return locale.nameInvalid;
    }
    return null;
  }

  static String? emailValidation(String value, AppLocalizations locale){
    if (value.isEmpty) {
      return locale.emailRequired;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(value)) {
      return locale.emailInvalid;
    }
    return null;
  }

  static String? passwordValidation(String value, AppLocalizations locale){
    if (value.isEmpty) {
      return locale.passwordRequired;
    } else if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$').hasMatch(value)) {
      return locale.passwordInvalid;
    }
    return null;
  }

  static String? rePasswordValidation(String value,String password, AppLocalizations locale){
    if (value.isEmpty) {
      return locale.passwordConfirmRequired;
    } else if (value != password) {
      return locale.passwordsNotMatch;
    }
    return null;
  }

  static String? titleEventValidator(String value, AppLocalizations locale)
  {
    if(value.isEmpty) return "Title is required";

    return null;
  }

  static String? descriptionEventValidator(String value, AppLocalizations locale)
  {
    if(value.isEmpty) return "Description is required";

    return null;
  }
}