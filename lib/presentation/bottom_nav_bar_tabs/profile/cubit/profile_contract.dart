import 'package:flutter/material.dart';

class ProfileState{
  String? pickedImage;
  ProfileState({this.pickedImage});

  ProfileState copyWith({String? pickedImage})
  {
    return ProfileState(pickedImage: pickedImage ?? this.pickedImage);
  }
}



sealed class ProfileAction{}

class ChangeProfilePicture extends ProfileAction{
  BuildContext context;
  ChangeProfilePicture(this.context);
}

class LogoutConfirmation extends ProfileAction{
  String message;
  LogoutConfirmation(this.message);
}

class Logout extends ProfileAction{}



sealed class ProfileNavigation{}

class ShowLoadingDialog extends ProfileNavigation{}

class ShowUpdatedDialog extends ProfileNavigation{
  String message;
  ShowUpdatedDialog(this.message);
}

class ShowLogoutConfirmationDialog extends ProfileNavigation{
  String message;
  ShowLogoutConfirmationDialog(this.message);
}

class NavigateToLoginScreen extends ProfileNavigation{}