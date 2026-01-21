import 'package:evently/core/base/base_cubit.dart';
import 'package:evently/core/utils/resources.dart';
import 'package:evently/data/network/results.dart';
import 'package:evently/domain/use_case/auth_use_case.dart';
import 'package:evently/presentation/login/cubit/login_contract.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginCubit extends BaseCubit<LoginState, LoginAction, LoginNavigation> {
  LoginCubit(this._authUseCase) : super(LoginState());

  final AuthUseCase _authUseCase;

  @override
  Future<void> doAction(LoginAction action) async {
    switch (action) {
      case LoginWithEmailAndPassword():
        {
          _loginWithEmailAndPassword(action.email, action.password);
        }
      case GoToRegisterScreen():
        {
          _goToRegisterScreen();
        }
      case VisibilityOfPassword():
        {
          _visibilityOfPassword();
        }
      case GoToForgetPasswordScreen():
        {
          _goToForgetPasswordScreen();
        }
    }
  }

  Future<void> _loginWithEmailAndPassword(String email, String password) async {
    emitNavigation(ShowLoadingDialog());
    var response = await _authUseCase.login(email: email, password: password);
    switch (response) {
      case Success<User?>():
        {
          emitNavigation(NavigateToHomeScreen());
        }
      case Failure<User?>():
        {
          emitNavigation(ShowErrorDialog());
          emit(
            state.copyWith(
              user: Resources.failure(
                exception: response.exception,
                message: response.message,
              ),
            ),
          );
        }
    }
  }

  void _visibilityOfPassword() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void _goToRegisterScreen() {
    emitNavigation(NavigateToRegisterScreen());
  }

  void _goToForgetPasswordScreen() {
    emitNavigation(NavigateToForgetPasswordScreen());
  }
}
