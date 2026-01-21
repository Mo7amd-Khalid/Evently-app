import 'package:evently/core/base/base_cubit.dart';
import 'package:evently/core/utils/resources.dart';
import 'package:evently/data/network/results.dart';
import 'package:evently/domain/use_case/auth_use_case.dart';
import 'package:evently/presentation/register/cubit/register_contract.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@injectable
class RegisterCubit extends BaseCubit<RegisterState, RegisterAction, RegisterNavigation>{

  RegisterCubit(this._useCase) : super(RegisterState());

  final AuthUseCase _useCase;
  @override
  Future<void> doAction(RegisterAction action) async{
    switch (action) {
      case RegisterWithEmailAndPassword():
        _registerWithEmailAndPassword(
          name: action.name,
          email: action.email,
          password: action.password,
        );
      case ChangeVisibilityOfPassword():
        _changeVisibilityOfPassword();
      case ChangeVisibilityOfRePassword():
        _changeVisibilityOfRePassword();
      case GoToLoginScreen():
        _goToLoginScreen();
      case SendVerificationEmail():
        _sendVerificationEmail();
      case CheckVerificationUser():
        _checkVerificationUser();
    }
  }


  Future<void> _registerWithEmailAndPassword(
      {required String name,required String email,required String password}) async
  {
    emitNavigation(ShowLoadingDialog());
    var response = await _useCase.register(name: name, email: email, password: password);
    switch (response) {
      case Success<UserCredential>():
        {
          emit(state.copyWith(user: Resources.success(data: response.data)));
          emitNavigation(ShowVerificationDialog());
        }
      case Failure<UserCredential>():
        {
          emitNavigation(ShowErrorDialog(response.message));
          emit(state.copyWith(user: Resources.failure(exception: response.exception, message: response.message)));
        }
    }
  }

  void _changeVisibilityOfPassword() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void _changeVisibilityOfRePassword() {
    emit(state.copyWith(obscureRePassword: !state.obscureRePassword));
  }

  void _goToLoginScreen() {
    emitNavigation(NavigateToLoginScreen());
  }

  void _sendVerificationEmail() {
    _useCase.sendVerificationEmail();
  }

  Future<void> _checkVerificationUser() async{

    await state.user.data!.user!.reload();
    var response = await _useCase.checkVerificationUser();
    switch (response) {
      case Success<User>():
        {
          print("successful");
          emit(state.copyWith(user: Resources.success()));
          emitNavigation(NavigateToLoginScreen());
        }
      case Failure<User>():
        {
          print(response.message);
          emit(state.copyWith(user: Resources.failure(exception: response.exception, message: response.message)));
        }

    }
  }


}