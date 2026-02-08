import 'package:evently/core/utils/resources.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterState {
  Resources<UserCredential> user;
  bool obscurePassword;
  bool obscureRePassword;

  RegisterState({
    this.user = const Resources.initial(),
    this.obscurePassword = true,
    this.obscureRePassword = true,
  });

  RegisterState copyWith({
    Resources<UserCredential>? user,
    bool? obscurePassword,
    bool? obscureRePassword,
  }) {
    return RegisterState(
      user: user ?? this.user,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureRePassword: obscureRePassword ?? this.obscureRePassword,
    );
  }
}

sealed class RegisterAction {}

class CheckVerificationUser extends RegisterAction {

}


class SendVerificationEmail extends RegisterAction {}

class RegisterWithEmailAndPassword extends RegisterAction {
  String name;
  String email;
  String password;

  RegisterWithEmailAndPassword({
    required this.name,
    required this.email,
    required this.password,
  });
}

class ChangeVisibilityOfPassword extends RegisterAction {}

class ChangeVisibilityOfRePassword extends RegisterAction {}

class GoToLoginScreen extends RegisterAction{}




sealed class RegisterNavigation {}

class ShowVerificationDialog extends RegisterNavigation {}

class ShowLoadingDialog extends RegisterNavigation {}

class ShowErrorDialog extends RegisterNavigation {
  String message;
  ShowErrorDialog(this.message);
}

class NavigateToLoginScreen extends RegisterNavigation {}
