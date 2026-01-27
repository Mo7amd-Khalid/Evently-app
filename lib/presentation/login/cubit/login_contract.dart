import 'package:evently/core/utils/resources.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginState{
  Resources<User> user;
  bool obscurePassword;
  LoginState({this.user = const Resources.initial(), this.obscurePassword = true});

  LoginState copyWith({Resources<User>? user, bool? obscurePassword}){
    return LoginState(user: user ?? this.user, obscurePassword: obscurePassword ?? this.obscurePassword);
  }

}


sealed class LoginAction{}

class VisibilityOfPassword extends LoginAction{}

class LoginWithEmailAndPassword extends LoginAction{
  String email;
  String password;
  LoginWithEmailAndPassword({required this.email, required this.password});
}

class GoToRegisterScreen extends LoginAction{}

class GoToForgetPasswordScreen extends LoginAction{}




sealed class LoginNavigation{}

class ShowLoadingDialog extends LoginNavigation{}

class ShowErrorDialog extends LoginNavigation{}

class NavigateToHomeScreen extends LoginNavigation{}

class NavigateToRegisterScreen extends LoginNavigation{}

class NavigateToForgetPasswordScreen extends LoginNavigation{}